from flask import Flask, render_template, request, redirect, url_for, flash, session, send_file, jsonify
from flask_sqlalchemy import SQLAlchemy
import os
from datetime import datetime
from sqlalchemy import func, inspect, text
from sqlalchemy.orm import sessionmaker
import time
from sqlalchemy.exc import OperationalError
from functools import wraps
from werkzeug.security import generate_password_hash, check_password_hash
import logging
from logging.handlers import RotatingFileHandler
import traceback
import subprocess
import csv
from io import StringIO, BytesIO
import pandas as pd

app = Flask(__name__)

# Configuration du logging
if not app.debug:
    file_handler = RotatingFileHandler('flask_app.log', maxBytes=10240, backupCount=10)
    file_handler.setFormatter(logging.Formatter(
        '%(asctime)s %(levelname)s: %(message)s [in %(pathname)s:%(lineno)d]'
    ))
    file_handler.setLevel(logging.INFO)
    app.logger.addHandler(file_handler)
    app.logger.setLevel(logging.INFO)
    app.logger.info('Flask app startup')

# Fonction pour construire l'URL de connexion PostgreSQL
def get_db_url():
    """Construire l'URL de connexion PostgreSQL depuis DATABASE_URL"""
    return os.getenv('DATABASE_URL', 'postgresql://testuser:testpassword@db:5432/testdb')

# Configuration de la base de données
app.config["SQLALCHEMY_DATABASE_URI"] = get_db_url()
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
app.config['SECRET_KEY'] = os.environ.get('SECRET_KEY', 'cle_defaut_insecurisee')
ADMIN_USER = os.environ.get('ADMIN_USER', 'CrunchlabUTBM2025')
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
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)  # Ajout de la relation
    user = db.relationship('User', backref='groupes')

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
    password = db.Column(db.String(255), nullable=False)  # Augmenté à 255 caractères

# Ajouter après les autres modèles
class Photo(db.Model):
    __tablename__ = 'photos'
    id_photo = db.Column(db.Integer, primary_key=True)
    id_groupe = db.Column(db.Integer, db.ForeignKey('groupe.id_groupe'), nullable=False)
    photo_data = db.Column(db.LargeBinary, nullable=False)
    filename = db.Column(db.String(255), nullable=False)
    upload_date = db.Column(db.DateTime, default=datetime.utcnow)

# Nouveau modèle pour les notes
class Rating(db.Model):
    __tablename__ = 'ratings'
    id_rating = db.Column(db.Integer, primary_key=True)
    rating = db.Column(db.Integer, nullable=False)
    comment = db.Column(db.Text, nullable=True)  # Nouveau champ pour les commentaires
    date_rated = db.Column(db.DateTime, default=datetime.utcnow)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    user = db.relationship('User', backref='ratings')  # Ajout de la relation

# Décorateur pour protéger les routes
def login_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if 'user_id' not in session:
            flash('Veuillez vous connecter pour accéder à cette page', 'error')
            return redirect(url_for('login'))
        return f(*args, **kwargs)
    return decorated_function

@app.route('/admin')
@login_required
def admin_home():
    try:
        user = User.query.get(session['user_id'])
        if user.username != ADMIN_USER:
            return redirect(url_for('home'))
            
        commandes = (db.session.query(Commande)
                    .join(Groupe)
                    .filter(Groupe.user_id == session['user_id'])
                    .all())
        results = []
        
        for commande in commandes:
            groupe = Groupe.query.get(commande.id_groupe)
            items = Items.query.filter_by(id_commande=commande.id_commande).all()
            
            if items:
                for item in items:
                    results.append((commande, groupe, item, len(items)))
        
        return render_template('home_admin.html', commandes=results)
    except Exception as e:
        app.logger.error(f"Erreur dans la route admin_home: {str(e)}")
        flash('Une erreur est survenue lors du chargement des données', 'error')
        return render_template('error.html', error=str(e))

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        
        user = User.query.filter_by(username=username).first()
        
        if user and check_password_hash(user.password, password):
            session['user_id'] = user.id
            session.permanent = True
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
        # Filtrer par utilisateur connecté
        commandes = (db.session.query(Commande)
                    .join(Groupe)
                    .filter(Groupe.user_id == session['user_id'])
                    .all())
        results = []
        
        for commande in commandes:
            groupe = Groupe.query.get(commande.id_groupe)
            items = Items.query.filter_by(id_commande=commande.id_commande).all()
            
            if items:
                for item in items:
                    results.append((commande, groupe, item, len(items)))
        
        return render_template('home.html', commandes=results)
    except Exception as e:
        app.logger.error(f"Erreur dans la route home: {str(e)}")
        flash('Une erreur est survenue lors du chargement des données', 'error')
        return render_template('error.html', error=str(e))

@app.route('/add_groupe', methods=['GET', 'POST'])
@login_required
def add_groupe():
    if request.method == 'POST':
        table = request.form['table']
        nom = request.form['nom']
        prenom = request.form['prenom']
        
        new_groupe = Groupe(
            table=table, 
            Nom=nom, 
            Prenom=prenom,
            user_id=session['user_id']  # Ajouter l'ID de l'utilisateur
        )
        db.session.add(new_groupe)
        db.session.commit()
        flash('Groupe ajouté avec succès!', 'success')
        return redirect(url_for('add_commande'))
    
    return render_template('add_groupe.html')

@app.route('/add_commande', methods=['GET', 'POST'])
@login_required
def add_commande():
    if request.method == 'POST':
        try:
            # Récupérer les données du formulaire
            id_groupe = request.form['id_groupe']
            noms = request.form.getlist('nom[]')
            techniques = request.form.getlist('technique[]')
            nombres = request.form.getlist('nombre[]')
            
            # Si c'est un nouveau groupe
            if id_groupe == 'new':
                new_groupe = Groupe(
                    table=request.form['new_table'],
                    Nom=request.form['new_nom'],
                    Prenom=request.form['new_prenom'],
                    user_id=session['user_id']
                )
                db.session.add(new_groupe)
                db.session.flush()  # Pour obtenir l'id du nouveau groupe
                id_groupe = new_groupe.id_groupe
            
            # Créer la commande
            new_commande = Commande(id_groupe=id_groupe)
            db.session.add(new_commande)
            db.session.flush()  # Pour obtenir l'id de la nouvelle commande
            
            # Ajouter les items
            for nom, technique, nombre in zip(noms, techniques, nombres):
                if nom.strip():  # Vérifier si le nom n'est pas vide
                    new_item = Items(
                        id_commande=new_commande.id_commande,
                        status="A rendre",
                        nom=nom.strip(),
                        technique=technique.strip() if technique.strip() else None,
                        nombre=int(nombre)
                    )
                    db.session.add(new_item)
            
            db.session.commit()
            flash('Commande ajoutée avec succès!', 'success')
            return redirect(url_for('home'))
            
        except Exception as e:
            db.session.rollback()
            flash(f'Erreur lors de l\'ajout de la commande: {str(e)}', 'error')
            return redirect(url_for('add_commande'))
    
    # GET request
    groupes = Groupe.query.filter_by(user_id=session['user_id']).all()
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
    
    # Récupérer les paramètres de tri et de recherche
    search = request.form.get('search', '')
    sort_column = request.form.get('sort_column', '-1')
    sort_direction = request.form.get('sort_direction', '1')
    
    return redirect(url_for('home', search=search, sort_column=sort_column, sort_direction=sort_direction))

@app.route('/groupe_items', methods=['GET', 'POST'])
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
        
        # Afficher tous les groupes
        groupes = Groupe.query.all()
        return render_template('groupe_items.html', groupes=groupes)
        
    except Exception as e:
        flash('Une erreur est survenue: ' + str(e), 'error')
        return redirect(url_for('groupe_items'))

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
    
    # Récupérer les paramètres de tri et de recherche
    search = request.form.get('search', '')
    sort_column = request.form.get('sort_column', '-1')
    sort_direction = request.form.get('sort_direction', '1')
    
    return redirect(url_for('home', search=search, sort_column=sort_column, sort_direction=sort_direction))

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

@app.route('/edit_groupe/<int:id_groupe>', methods=['GET', 'POST'])
@login_required
def edit_groupe(id_groupe):
    groupe = Groupe.query.get_or_404(id_groupe)
    
    # Vérifier que le groupe appartient à l'utilisateur connecté
    if groupe.user_id != session['user_id']:
        flash('Vous n\'avez pas la permission de modifier ce groupe', 'error')
        return redirect(url_for('home'))
    
    if request.method == 'POST':
        try:
            groupe.table = request.form['table']
            groupe.Nom = request.form['nom']
            groupe.Prenom = request.form['prenom']
            
            db.session.commit()
            flash('Groupe modifié avec succès!', 'success')
            return redirect(url_for('home'))
        except Exception as e:
            db.session.rollback()
            flash('Erreur lors de la modification: ' + str(e), 'error')
    
    return render_template('edit_groupe.html', groupe=groupe)

def init_db():
    try:
        with app.app_context():
            # Vérifier la connexion à la base de données
            wait_for_db()
            # Supprimer toutes les tables existantes
            #db.drop_all()
            # Créer les tables
            db.create_all()
            app.logger.info('Database initialized successfully')
            return True
    except Exception as e:
        app.logger.error(f'Database initialization error: {str(e)}')
        return False

def restore_from_sql(sql_file_path):
    try:
        with app.app_context():
            with open(sql_file_path, 'r') as file:
                sql_commands = file.read()
            
            # Connexion directe avec SQLAlchemy
            with db.engine.connect() as conn:
                # Désactiver les contraintes
                conn.execute(text("SET session_replication_role = 'replica';"))
                
                try:
                    # Exécuter chaque commande SQL séparément
                    for command in sql_commands.split(';'):
                        if command.strip():
                            try:
                                conn.execute(text(command.strip()))
                            except Exception as e:
                                app.logger.warning(f'Erreur sur la commande: {str(e)}')
                                continue
                    
                    conn.execute(text("SET session_replication_role = 'origin';"))
                    conn.commit()
                    app.logger.info('Database restored successfully')
                    return True
                except Exception as e:
                    conn.execute(text("SET session_replication_role = 'origin';"))
                    raise e
                
    except Exception as e:
        app.logger.error(f'Error restoring database: {str(e)}')
        return False

@app.route('/restore', methods=['GET', 'POST'])
@login_required
def restore_db():
    if request.method == 'POST':
        try:
            if 'sql_file' not in request.files:
                flash('Aucun fichier sélectionné', 'error')
                return redirect(request.url)

            sql_file = request.files['sql_file']
            if sql_file.filename == '':
                flash('Aucun fichier sélectionné', 'error')
                return redirect(request.url)

            if not sql_file.filename.endswith('.sql'):
                flash('Le fichier doit être un fichier SQL', 'error')
                return redirect(request.url)

            # Créer le répertoire temp s'il n'existe pas
            os.makedirs('temp', exist_ok=True)
            filepath = os.path.join('temp', 'backup.sql')

            try:
                # Sauvegarder le fichier
                sql_file.save(filepath)
                
                # Restaurer la base de données
                restore_from_sql(filepath)
                flash('Base de données restaurée avec succès!', 'success')
                
            except Exception as e:
                flash(f'Erreur lors de la restauration: {str(e)}', 'error')
            
            finally:
                # Nettoyer le fichier temporaire
                if os.path.exists(filepath):
                    os.remove(filepath)

        except Exception as e:
            flash(f'Erreur: {str(e)}', 'error')

        return redirect(url_for('restore_db'))
    
    return render_template('restore.html')

@app.route('/backup')
@login_required
def backup():
    return render_template('backup.html')

@app.route('/download_csv/<table>')
@login_required
def download_csv(table):
    try:
        si = StringIO()
        cw = csv.writer(si)
        
        if table == 'groupe':
            # Récupérer les groupes de l'utilisateur connecté
            rows = Groupe.query.filter_by(user_id=session['user_id']).all()
            cw.writerow(['id_groupe', 'table', 'Nom', 'Prenom'])
            for row in rows:
                cw.writerow([row.id_groupe, row.table, row.Nom, row.Prenom])
        
        elif table == 'commande':
            # Récupérer les commandes liées aux groupes de l'utilisateur
            rows = db.session.query(Commande).join(Groupe).filter(Groupe.user_id == session['user_id']).all()
            cw.writerow(['id_commande', 'date_hour', 'id_groupe'])
            for row in rows:
                cw.writerow([row.id_commande, row.date_hour, row.id_groupe])
        
        elif table == 'items':
            # Récupérer les items liés aux commandes de l'utilisateur
            rows = (db.session.query(Items)
                   .join(Commande)
                   .join(Groupe)
                   .filter(Groupe.user_id == session['user_id'])
                   .all())
            cw.writerow(['id_cart', 'id_commande', 'status', 'nom', 'technique', 'nombre'])
            for row in rows:
                cw.writerow([row.id_cart, row.id_commande, row.status, row.nom, row.technique, row.nombre])
        
        output = si.getvalue()
        si.close()
        
        return send_file(
            StringIO(output),
            mimetype='text/csv',
            as_attachment=True,
            download_name=f'{table}.csv'
        )
        
    except Exception as e:
        app.logger.error(f'Erreur lors de la génération du CSV: {str(e)}')
        flash('Erreur lors de la génération du fichier CSV', 'error')
        return redirect(url_for('backup'))

@app.route('/export_all_data')
@login_required
def export_all_data():
    try:
        si = StringIO()
        cw = csv.writer(si)
        
        # Export Groupes
        cw.writerow(['=== GROUPES ==='])
        cw.writerow(['id_groupe', 'table', 'Nom', 'Prenom'])
        rows = Groupe.query.filter_by(user_id=session['user_id']).all()
        for row in rows:
            cw.writerow([row.id_groupe, row.table, row.Nom, row.Prenom])
        
        cw.writerow([])  # Empty line between tables
        
        # Export Commandes
        cw.writerow(['=== COMMANDES ==='])
        cw.writerow(['id_commande', 'date_hour', 'id_groupe'])
        rows = db.session.query(Commande).join(Groupe).filter(Groupe.user_id == session['user_id']).all()
        for row in rows:
            cw.writerow([row.id_commande, row.date_hour, row.id_groupe])
            
        cw.writerow([])  # Empty line between tables
        
        # Export Items
        cw.writerow(['=== ITEMS ==='])
        cw.writerow(['id_cart', 'id_commande', 'status', 'nom', 'technique', 'nombre'])
        rows = (db.session.query(Items)
               .join(Commande)
               .join(Groupe)
               .filter(Groupe.user_id == session['user_id'])
               .all())
        for row in rows:
            cw.writerow([row.id_cart, row.id_commande, row.status, row.nom, row.technique, row.nombre])
        
        # Convert to BytesIO
        output = BytesIO()
        output.write(si.getvalue().encode('utf-8-sig'))  # Use UTF-8 with BOM for Excel compatibility
        output.seek(0)
        si.close()
        
        return send_file(
            output,
            mimetype='text/csv',
            as_attachment=True,
            download_name='export_complet.csv'
        )
        
    except Exception as e:
        app.logger.error(f'Erreur lors de la génération du CSV: {str(e)}')
        flash('Erreur lors de la génération du fichier CSV', 'error')
        return redirect(url_for('home'))

@app.route('/setup', methods=['GET', 'POST'])
@login_required  # Ajout du décorateur login_required
def setup():
    try:
        # Vérifier si l'utilisateur est admin
        user = User.query.get(session['user_id'])
        if user.username != ADMIN_USER:
            flash('Accès non autorisé', 'error')
            return redirect(url_for('home'))
            
        if request.method == 'POST':
            username = request.form.get('username')
            password = request.form.get('password')
            
            if not username or not password:
                flash('Username and password are required', 'error')
                return render_template('setup.html')

            # Initialiser la base de données
            init_db()
            
            # Utiliser SHA256 pour le hachage du mot de passe
            hashed_password = generate_password_hash(password, method='sha256')
            new_user = User(username=username, password=hashed_password)
            db.session.add(new_user)
            db.session.commit()
            
            flash('Configuration terminée avec succès!', 'success')
            return redirect(url_for('login'))
            
        return render_template('setup.html')
        
    except Exception as e:
        app.logger.error(f'Setup error: {str(e)}')
        db.session.rollback()
        flash(f'Erreur: {str(e)}', 'error')
        return render_template('setup.html')

@app.route('/download_sql_backup')
@login_required
def download_sql_backup():
    try:
        # Récupérer les informations de connexion depuis l'URL
        db_url = app.config['SQLALCHEMY_DATABASE_URI']
        url_parts = db_url.split('/')
        db_name = url_parts[-1]
        user_pass = url_parts[2].split('@')[0]
        host_port = url_parts[2].split('@')[1]
        
        username = user_pass.split(':')[0]
        password = user_pass.split(':')[1]
        host = host_port.split(':')[0]
        port = host_port.split(':')[1]

        # Créer un nom de fichier temporaire unique
        timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
        temp_filename = f'backup_{timestamp}.sql'

        # Configuration de pg_dump
        env = os.environ.copy()
        env['PGPASSWORD'] = password

        # Exécuter pg_dump et capturer la sortie
        cmd = [
            'pg_dump',
            '-h', host,
            '-p', port,
            '-U', username,
            '-F', 'p',  # Format plain text
            db_name
        ]

        # Exécuter pg_dump et capturer la sortie directement
        result = subprocess.run(cmd, env=env, capture_output=True, text=True)
        
        if result.returncode != 0:
            raise Exception(f"pg_dump failed: {result.stderr}")

        # Créer un BytesIO object avec le contenu
        sql_content = BytesIO(result.stdout.encode('utf-8'))
        sql_content.seek(0)

        return send_file(
            sql_content,
            mimetype='application/sql',
            as_attachment=True,
            download_name=f'crunchtime_backup_{timestamp}.sql'
        )

    except Exception as e:
        app.logger.error(f'Erreur lors de la génération de la sauvegarde SQL: {str(e)}')
        flash('Erreur lors de la génération de la sauvegarde SQL', 'error')
        return redirect(url_for('backup'))

@app.route('/import', methods=['GET', 'POST'])
@login_required
def import_data():
    if request.method == 'POST':
        try:
            if 'groupe_file' not in request.files or \
               'commande_file' not in request.files or \
               'items_file' not in request.files:
                flash('Tous les fichiers sont requis', 'error')
                return redirect(request.url)

            # Lire les fichiers CSV
            groupe_file = request.files['groupe_file']
            commande_file = request.files['commande_file']
            items_file = request.files['items_file']

            # Importer les groupes
            df_groupes = pd.read_csv(groupe_file)
            for _, row in df_groupes.iterrows():
                groupe = Groupe(
                    table=row['table'],
                    Nom=row['Nom'],
                    Prenom=row['Prenom'],
                    user_id=session['user_id']
                )
                db.session.add(groupe)
            db.session.commit()

            # Créer un mapping des anciens ID vers les nouveaux ID
            groupe_mapping = {g.id_groupe: g.id_groupe for g in Groupe.query.filter_by(user_id=session['user_id']).all()}

            # Importer les commandes
            df_commandes = pd.read_csv(commande_file)
            for _, row in df_commandes.iterrows():
                commande = Commande(
                    date_hour=datetime.strptime(row['date_hour'], '%Y-%m-%d %H:%M:%S.%f'),
                    id_groupe=groupe_mapping[row['id_groupe']]
                )
                db.session.add(commande)
            db.session.commit()

            # Créer un mapping pour les commandes
            commande_mapping = {c.id_commande: c.id_commande for c in Commande.query.all()}

            # Importer les items
            df_items = pd.read_csv(items_file)
            for _, row in df_items.iterrows():
                item = Items(
                    id_commande=commande_mapping[row['id_commande']],
                    status=row['status'],
                    nom=row['nom'],
                    technique=row['technique'],
                    nombre=row['nombre']
                )
                db.session.add(item)
            db.session.commit()

            flash('Données importées avec succès!', 'success')
            return redirect(url_for('home'))

        except Exception as e:
            db.session.rollback()
            app.logger.error(f'Erreur lors de l\'importation: {str(e)}')
            flash(f'Erreur lors de l\'importation: {str(e)}', 'error')
            return redirect(request.url)

    return render_template('import_data.html')

# Ajouter les nouvelles routes
@app.route('/photos', methods=['GET', 'POST'])
@login_required
def photos():
    if request.method == 'POST':
        try:
            id_groupe = request.form.get('groupe')
            if id_groupe == 'new':
                # Créer un nouveau groupe
                new_groupe = Groupe(
                    table=request.form['new_table'],
                    Nom=request.form['new_nom'],
                    Prenom=request.form['new_prenom'],
                    user_id=session['user_id']
                )
                db.session.add(new_groupe)
                db.session.commit()
                id_groupe = new_groupe.id_groupe
            
            # Gérer les photos
            photos = request.files.getlist('photos')
            for photo in photos:
                if photo and photo.filename:
                    photo_data = photo.read()
                    new_photo = Photo(
                        id_groupe=id_groupe,
                        photo_data=photo_data,
                        filename=photo.filename
                    )
                    db.session.add(new_photo)
            
            db.session.commit()
            flash('Photos ajoutées avec succès!', 'success')
            return redirect(url_for('photos'))
            
        except Exception as e:
            db.session.rollback()
            flash(f'Erreur: {str(e)}', 'error')
    
    # Récupérer les groupes de l'utilisateur connecté avec leur photo la plus récente
    latest_photos = (db.session.query(
        Photo,
        Groupe,
        func.count(Photo.id_photo).over(partition_by=Photo.id_groupe).label('total_photos'),
        func.row_number().over(
            partition_by=Photo.id_groupe,
            order_by=Photo.upload_date.desc()
        ).label('rn')
    ).join(Groupe)
     .filter(Groupe.user_id == session['user_id'])
     .subquery())

    # Sélectionner uniquement la photo la plus récente de chaque groupe
    photos = (db.session.query(latest_photos)
             .filter(latest_photos.c.rn == 1)
             .all())
    
    groupes = Groupe.query.filter_by(user_id=session['user_id']).all()
    return render_template('photos.html', groupes=groupes, photos=photos)

@app.route('/photo/<int:id_photo>')
@login_required
def get_photo(id_photo):
    photo = Photo.query.get_or_404(id_photo)
    return send_file(
        BytesIO(photo.photo_data),
        mimetype='image/jpeg',
        as_attachment=False,
        download_name=photo.filename
    )

@app.route('/delete_photo/<int:id_photo>', methods=['POST'])
@login_required
def delete_photo(id_photo):
    photo = Photo.query.get_or_404(id_photo)
    try:
        db.session.delete(photo)
        db.session.commit()
        flash('Photo supprimée avec succès!', 'success')
    except Exception as e:
        db.session.rollback()
        flash(f'Erreur lors de la suppression: {str(e)}', 'error')
    return redirect(url_for('photos'))

@app.route('/submit_rating', methods=['POST'])
@login_required
def submit_rating():
    try:
        rating = request.form.get('rating')
        comment = request.form.get('comment', '').strip()
        
        if rating:
            new_rating = Rating(
                rating=int(rating),
                comment=comment if comment else None,
                user_id=session['user_id']
            )
            db.session.add(new_rating)
            db.session.commit()
            
            # Calculer les nouvelles statistiques
            avg_rating = db.session.query(func.avg(Rating.rating)).scalar() or 0
            total_ratings = db.session.query(func.count(Rating.id_rating)).scalar()
            ratings_dist = db.session.query(
                Rating.rating,
                func.count(Rating.id_rating)
            ).group_by(Rating.rating).all()
            
            # Formater la distribution des notes
            distribution = {i: 0 for i in range(1, 6)}
            for r, count in ratings_dist:
                distribution[r] = count
            
            return jsonify({
                'success': True,
                'avgRating': float(avg_rating),
                'totalRatings': total_ratings,
                'distribution': distribution
            })
            
    except Exception as e:
        app.logger.error(f"Erreur lors de l'enregistrement de la note: {str(e)}")
        return jsonify({'success': False, 'error': str(e)})

@app.route('/ratings')
@login_required
def view_ratings():
    try:
        # Récupérer toutes les notes avec les noms d'utilisateurs
        ratings = db.session.query(Rating, User.username)\
            .join(User)\
            .order_by(Rating.date_rated.desc())\
            .all()

        # Calculer la moyenne des notes
        average_rating = db.session.query(func.avg(Rating.rating)).scalar() or 0
        total_ratings = db.session.query(func.count(Rating.id_rating)).scalar() or 0

        # Formater les données pour le template
        formatted_ratings = []
        for rating, username in ratings:
            rating_dict = {
                'rating': rating.rating,
                'date_rated': rating.date_rated,
                'username': username
            }
            formatted_ratings.append(rating_dict)

        return render_template('ratings.html',
                             ratings=formatted_ratings,
                             average_rating=float(average_rating),
                             total_ratings=total_ratings)
    except Exception as e:
        app.logger.error(f"Erreur lors de l'affichage des notes: {str(e)}")
        flash("Erreur lors de l'affichage des notes", 'error')
        return redirect(url_for('home'))

@app.route('/ratings_dashboard')
@login_required
def ratings_dashboard():
    try:
        # Statistiques générales
        avg_rating = db.session.query(func.avg(Rating.rating)).scalar() or 0
        total_ratings = db.session.query(func.count(Rating.id_rating)).scalar()
        
        # Distribution des notes
        ratings_dist = db.session.query(
            Rating.rating,
            func.count(Rating.id_rating)
        ).group_by(Rating.rating).all()
        
        # Derniers commentaires
        recent_ratings = db.session.query(Rating, User)\
            .join(User)\
            .order_by(Rating.date_rated.desc())\
            .limit(10)\
            .all()
        
        # Evolution des notes dans le temps
        ratings_evolution = db.session.query(
            func.date(Rating.date_rated),
            func.avg(Rating.rating)
        ).group_by(func.date(Rating.date_rated))\
         .order_by(func.date(Rating.date_rated))\
         .all()
        
        return render_template('ratings_dashboard.html',
                             avg_rating=float(avg_rating),
                             total_ratings=total_ratings,
                             ratings_dist=dict(ratings_dist),
                             recent_ratings=recent_ratings,
                             ratings_evolution=ratings_evolution)
                             
    except Exception as e:
        app.logger.error(f"Erreur lors de l'affichage du dashboard: {str(e)}")
        flash("Erreur lors de l'affichage du dashboard", 'error')
        return redirect(url_for('home'))

@app.route('/groupe_photos/<int:id_groupe>')
@login_required
def groupe_photos(id_groupe):
    try:
        groupe = Groupe.query.get_or_404(id_groupe)
        
        # Vérifier que l'utilisateur a accès à ce groupe
        if groupe.user_id != session['user_id']:
            flash('Accès non autorisé', 'error')
            return redirect(url_for('photos'))
        
        # Récupérer toutes les photos du groupe
        photos = Photo.query.filter_by(id_groupe=id_groupe).order_by(Photo.upload_date.desc()).all()
        
        return render_template('groupe_photos.html', groupe=groupe, photos=photos)
    except Exception as e:
        app.logger.error(f"Erreur lors de l'affichage des photos du groupe: {str(e)}")
        flash('Une erreur est survenue', 'error')
        return redirect(url_for('photos'))

if __name__ == "__main__":
    if not os.path.exists('logs'):
        os.mkdir('logs')
    init_db()  # Initialiser la base de données au démarrage
    app.run(debug=False, host="0.0.0.0", port=5000)
