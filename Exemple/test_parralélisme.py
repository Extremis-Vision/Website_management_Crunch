from concurrent.futures import ThreadPoolExecutor, as_completed
import time

# Fonctions simples pour des opérations mathématiques
def addition(a, b):
    time.sleep(1)  # Simule un délai d'une seconde
    return a + b

def soustraction(a, b):
    time.sleep(1.5)  # Simule un délai d'1.5 secondes
    return a - b

def multiplication(a, b):
    time.sleep(2)  # Simule un délai de 2 secondes
    return a * b

def division(a, b):
    time.sleep(1)  # Simule un délai d'une seconde
    if b == 0:
        return "Erreur: Division par zéro"
    return a / b

# Fonction principale pour lancer les tâches en parallèle
def test_math_operations():
    # Dictionnaire des opérations avec leurs arguments
    tasks = {
        "Addition": lambda: addition(5, 3),
        "Soustraction": lambda: soustraction(10, 4),
        "Multiplication": lambda: multiplication(7, 6),
        "Division": lambda: division(8, 2),
        "Division_Par_Zero": lambda: division(5, 0)
    }

    results = {}  # Pour stocker les résultats
    start_time = time.time()  # Démarre le chronomètre

    # Lancement en parallèle des fonctions avec ThreadPoolExecutor
    with ThreadPoolExecutor(max_workers=4) as executor:  # 4 threads maximum
        futures = {executor.submit(task): name for name, task in tasks.items()}

        for future in as_completed(futures):
            name = futures[future]
            try:
                results[name] = future.result()  # Récupère le résultat de chaque fonction
            except Exception as e:
                results[name] = f"Erreur: {e}"

    # Affichage des résultats
    print("\n=== Résultats des Opérations Mathématiques ===")
    for name, result in results.items():
        print(f"{name}: {result}")

    end_time = time.time()  # Fin du chronomètre
    print(f"\nTemps total d'exécution parallèle: {end_time - start_time:.2f} secondes")

# Lancer les tests
if __name__ == "__main__":
    test_math_operations()
