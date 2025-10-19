package sprint2;


public class SiteController {

    @HandleUrl("/home")
    public void afficherAccueil() {
        System.out.println("Page d’accueil");
    }

    @HandleUrl("/produits")
    public void afficherProduits() {
        System.out.println("Liste des produits");
    }

    @HandleUrl("/contact")
    public void afficherContact() {
        System.out.println("Page contact");
    }
}
