from flask import Flask, render_template, request, redirect, url_for, flash, session
from flask_sqlalchemy import SQLAlchemy
import os
from datetime import datetime
from sqlalchemy import func, inspect
from sqlalchemy.orm import sessionmaker
import time
from sqlalchemy.exc import OperationalError
from functools import wraps
from werkzeug.security import generate_password_hash, check_password_hash

app = Flask(__name__)

# Configuration de la base de données
app.config["SQLALCHEMY_DATABASE_URI"] = os.getenv("DATABASE_URL")
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
app.config['SECRET_KEY'] = os.environ.get('SECRET_KEY', 'cle_defaut_insecurisee')
ADMIN_USER = os.environ.get('ADMIN_USER', 'admin')
ADMIN_PASSWORD = os.environ.get('ADMIN_PASSWORD', 'password')

db = SQLAlchemy(app)

# Fonction pour attendre que la base de données soit prête
def wait_for_db(max_retries=5, delay_seconds=5):
    for i in range(max_retries):
        try:
            # Tenter de se connecter à la base de données
            inspector = inspect(db.engine)
            inspector.get_table_names()
            return True
        except OperationalError as e:
            if i < max_retries - 1:
                time.sleep(delay_seconds)
                continue
            else:
                raise e

class Groupe(db.Model):
    __tablename__ = 'groupe'
    id_groupe = db.Column(db.Integer, primary_key=True)
    table = db.Column(db.String(100), nullable=False)
    Nom = db.Column(db.String(100), nullable=False)
    Prenom = db.Column(db.String(100), nullable=False)

class Commande(db.Model):
    __tablename__ = 'commande'
    id_commande = db.Column(db.Integer, primary_key=True)
    date_hour = db.Column(db.DateTime, nullable=False, default=datetime.utcnow)
    id_groupe = db.Column(db.Integer, db.ForeignKey('groupe.id_groupe'), nullable=False)

class Items(db.Model):
    __tablename__ = 'items'
    id_cart = db.Column(db.Integer, primary_key=True)
    id_commande = db.Column(db.Integer, db.ForeignKey('commande.id_commande'), nullable=False)
    status = db.Column(db.String(100), nullable=False, default="A rendre")
    nom = db.Column(db.String(100), nullable=False)
    technique = db.Column(db.String(100), nullable=True)
    nombre = db.Column(db.Integer, nullable=False, default=1)

# Ajout du modèle User après les autres modèles
class User(db.Model):
    __tablename__ = 'users'
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False)
    password = db.Column(db.String(120), nullable=False)

# Décorateur pour protéger les routes
def login_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if 'user_id' not in session:
            flash('Veuillez vous connecter pour accéder à cette page', 'error')
            return redirect(url_for('login'))
        return f(*args, **kwargs)
    return decorated_function

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        
        user = User.query.filter_by(username=username).first()
        
        if user and check_password_hash(user.password, password):
            session['user_id'] = user.id
            flash('Connexion réussie!', 'success')
            return redirect(url_for('home'))
        else:
            flash("Nom d'utilisateur ou mot de passe incorrect", 'error')
            
    return render_template('login.html')

@app.route('/logout')
def logout():
    session.pop('user_id', None)
    flash('Vous avez été déconnecté', 'success')
    return redirect(url_for('login'))

@app.route('/')
@login_required
def home():
    try:
        # Requête simplifiée
        commandes = db.session.query(Commande).join(Groupe).all()
        results = []
        
        for commande in commandes:
            groupe = Groupe.query.get(commande.id_groupe)
            items = Items.query.filter_by(id_commande=commande.id_commande).all()
            
            if items:  # Seulement ajouter si la commande a des items
                for item in items:
                    results.append((commande, groupe, item, len(items)))
        
        return render_template('home.html', commandes=results)
    except Exception as e:
        print(f"Erreur dans la route home: {str(e)}")
        flash('Une erreur est survenue lors du chargement des données', 'error')
        return render_template('error.html', error=str(e))

@app.route('/add_groupe', methods=['GET', 'POST'])
@login_required
def add_groupe():
    if request.method == 'POST':
        table = request.form['table']
        nom = request.form['nom']
        prenom = request.form['prenom']
        
        new_groupe = Groupe(table=table, Nom=nom, Prenom=prenom)
        db.session.add(new_groupe)
        db.session.commit()
        flash('Groupe ajouté avec succès!', 'success')
        return redirect(url_for('add_commande'))
    
    return render_template('add_groupe.html')

@app.route('/add_commande', methods=['GET', 'POST'])
@login_required
def add_commande():
    if request.method == 'POST':
        id_groupe = request.form['id_groupe']
        noms = request.form.getlist('nom[]')
        techniques = request.form.getlist('technique[]')
        nombres = request.form.getlist('nombre[]')
        
        new_commande = Commande(id_groupe=id_groupe)
        db.session.add(new_commande)
        db.session.commit()
        
        for nom, technique, nombre in zip(noms, techniques, nombres):
            if nom.strip():  # Seulement vérifier si le nom est rempli
                new_item = Items(
                    id_commande=new_commande.id_commande,
                    status="A rendre",
                    nom=nom.strip(),
                    technique=technique.strip() if technique.strip() else None,  # Technique peut être vide
                    nombre=int(nombre)
                )
                db.session.add(new_item)
        
        db.session.commit()
        flash('Commande ajoutée avec succès!', 'success')
        return redirect(url_for('home'))
    
    groupes = Groupe.query.all()
    return render_template('add_commande.html', groupes=groupes)

@app.route('/edit_commande/<int:id_commande>', methods=['GET', 'POST'])
@login_required
def edit_commande(id_commande):
    if request.method == 'POST':
        noms = request.form.getlist('nom[]')
        techniques = request.form.getlist('technique[]')
        nombres = request.form.getlist('nombre[]')
        
        commande = Commande.query.get_or_404(id_commande)
        
        for nom, technique, nombre in zip(noms, techniques, nombres):
            if nom.strip():  # Seulement vérifier si le nom est rempli
                new_item = Items(
                    id_commande=id_commande,
                    status="A rendre",
                    nom=nom.strip(),
                    technique=technique.strip() if technique.strip() else None,  # Technique peut être vide
                    nombre=int(nombre)
                )
                db.session.add(new_item)
        
        db.session.commit()
        flash('Items ajoutés avec succès!', 'success')
        return redirect(url_for('home'))
    
    commande = Commande.query.get_or_404(id_commande)
    items = Items.query.filter_by(id_commande=id_commande).all()
    return render_template('edit_commande.html', commande=commande, items=items)

@app.route('/change_status/<int:id_cart>', methods=['POST'])
@login_required
def change_status(id_cart):
    item = Items.query.get_or_404(id_cart)
    item.status = "Rendu" if item.status == "A rendre" else "A rendre"
    db.session.commit()
    flash('Statut modifié avec succès!', 'success')
    return redirect(url_for('home'))

@app.route('/groupe_items', methods=['GET', 'POST'])
@login_required
def groupe_items():
    try:
        if request.method == 'POST':
            id_groupe = request.form['id_groupe']
            groupe = Groupe.query.get_or_404(id_groupe)
            
            # Récupérer toutes les commandes du groupe
            commandes = Commande.query.filter_by(id_groupe=id_groupe).all()
            
            items_a_rendre = []
            items_rendus = []
            
            for commande in commandes:
                items = Items.query.filter_by(id_commande=commande.id_commande).all()
                for item in items:
                    if item.status == "A rendre":
                        items_a_rendre.append(item)
                    else:
                        items_rendus.append(item)
            
            return render_template('groupe_items.html', 
                                groupe=groupe,
                                items_a_rendre=items_a_rendre,
                                items_rendus=items_rendus)
        
        # Si GET, afficher le formulaire de sélection
        groupes = Groupe.query.all()
        return render_template('groupe_items.html', groupes=groupes)
        
    except Exception as e:
        flash('Une erreur est survenue: ' + str(e), 'error')
        return redirect(url_for('home'))

@app.route('/delete_item/<int:id_cart>', methods=['POST'])
@login_required
def delete_item(id_cart):
    item = Items.query.get_or_404(id_cart)
    try:
        db.session.delete(item)
        db.session.commit()
        flash('Item supprimé avec succès!', 'success')
    except Exception as e:
        db.session.rollback()
        flash('Erreur lors de la suppression: ' + str(e), 'error')
    return redirect(url_for('home'))

@app.route('/edit_item/<int:id_cart>', methods=['GET', 'POST'])
@login_required
def edit_item(id_cart):
    item = Items.query.get_or_404(id_cart)
    if request.method == 'POST':
        try:
            item.nom = request.form['nom']
            item.technique = request.form['technique']
            item.nombre = int(request.form['nombre'])
            db.session.commit()
            flash('Item modifié avec succès!', 'success')
            return redirect(url_for('home'))
        except Exception as e:
            db.session.rollback()
            flash('Erreur lors de la modification: ' + str(e), 'error')
    return render_template('edit_item.html', item=item)

# Ajouter une route pour créer un utilisateur initial (à utiliser avec précaution)
@app.route('/setup', methods=['GET', 'POST'])
def setup():
    if User.query.first() is not None:
        flash('Setup already completed', 'error')
        return redirect(url_for('login'))
    
    # Création automatique de l'utilisateur avec les variables d'environnement
    hashed_password = generate_password_hash(ADMIN_PASSWORD)
    new_user = User(username=ADMIN_USER, password=hashed_password)
    
    db.session.add(new_user)
    db.session.commit()
    
    flash('User created successfully', 'success')
    return redirect(url_for('login'))

if __name__ == "__main__":
    with app.app_context():
        db.create_all()
    app.run(debug=False, host="0.0.0.0", port=5000)
