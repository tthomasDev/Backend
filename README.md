

- Base de données:

> Choisir une bonne de données MySQL
> Créer un nom de base de données dans celle-ci






- Configurer le fichier pom.xml: utilisation d'un "profile":

> Choisir un "profile" ou créer un nouveau "profile"
> Renseigner le chemin et le nom de la base de données entre les chevrons du champ <jdbc.url></jdbc.url>
> Renseigner le login et password d'accès à la base de données 





- Compiler le projet avec Maven:

> Lancer la commande:  $mvn compile





- Executer le project avec Maven et Jetty:

> Lancer la commande:  $mvn jetty:run -P<profile-name>





- Executer les tests unitaires depuis Eclipse:

> Click droit sur le projet > Run As > JUnit Test
(attention, les tests unitaires ne fonctionnement pas si ils sont lançés avec Maven
