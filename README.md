---

# Mini-C-Compiler

# Auteur : Pereira Oliveira Tomas, L3-B, 21001378.

## Description
Petit compilateur basique pour le langage C, réalisé en Ocaml pour le cours d'interprétation et de compilation de la licence informatique de l'Université Paris 8.

## Fonctionnalités
- **Types supportés** : `Int`, `Bool`, `String`, `Void`.
- **Gestion des commentaires**.
- **Assignation de variables typées**.
- **Structures de contrôle** : 
  - Blocs d'instructions (`if`, `else`).
  - Boucles (`while`).
- **Affichage** : Impression de valeurs brutes et de variables (`print`) fonctionnant pour tout les type et avec un nombre dynamique d'argument.
- **Appel de fonction**
- **Retour de valeur**
  
## Opérations
- **Sur les entiers** :
  - Addition (`+`)
  - Soustraction (`-`)
  - Division (`/`,`%`)
  - Multiplication (`*`)
  - Comparaison (`<`, `>`, `<=`, `>=`, `!=`, `!`)
- **Sur les booléens** :
  - And (`&&`)
  - Or (`||`)
  - Xor

## Syntaxe
La syntaxe du langage est similaire à celle du C. Voici quelques exemples typiques de cette syntaxe :

```c
// Déclaration et assignation de variable
int a = 1;

// Structure conditionnelle
if (a == 1) {
  a = a + 1;
};

// Boucle
while (a == 1) {
  print("Boucle");
  a + 1;
};

if(a!=3){
return a;
}
else{
a = a + 1;
};

// Affichage et retour
print(a);
return 1;
```

---
