from app import app, db, Groupe, Commande, Items
import pandas as pd
from datetime import datetime

def import_data(user_id):
    try:
        with app.app_context():
            # Importer les groupes
            df_groupes = pd.read_csv('donnees/groupe.csv')
            for _, row in df_groupes.iterrows():
                groupe = Groupe(
                    id_groupe=row['id_groupe'],
                    table=row['table'],
                    Nom=row['Nom'],
                    Prenom=row['Prenom'],
                    user_id=user_id  # Assigner l'user_id à chaque groupe
                )
                db.session.add(groupe)
            db.session.commit()

            # Importer les commandes
            df_commandes = pd.read_csv('donnees/commande.csv')
            for _, row in df_commandes.iterrows():
                commande = Commande(
                    id_commande=row['id_commande'],
                    date_hour=datetime.strptime(row['date_hour'], '%Y-%m-%d %H:%M:%S.%f'),
                    id_groupe=row['id_groupe']
                )
                db.session.add(commande)
            db.session.commit()

            # Importer les items
            df_items = pd.read_csv('donnees/items.csv')
            for _, row in df_items.iterrows():
                item = Items(
                    id_cart=row['id_cart'],
                    id_commande=row['id_commande'],
                    status=row['status'],
                    nom=row['nom'],
                    technique=row['technique'],
                    nombre=row['nombre']
                )
                db.session.add(item)
            db.session.commit()

            print("Données importées avec succès!")
            return True

    except Exception as e:
        print(f"Erreur lors de l'importation: {str(e)}")
        db.session.rollback()
        return False

if __name__ == "__main__":
    # Remplacer XXX par l'ID de l'utilisateur auquel vous voulez attribuer les données
    user_id = int(input("Entrez l'ID de l'utilisateur: "))
    import_data(user_id)
