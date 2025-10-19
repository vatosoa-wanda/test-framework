package sprint2;
import sprint2.SiteController; // Replace with actual package
import java.lang.reflect.Method;

public class MainScanner {
    public static void main(String[] args) {
        Class<SiteController> clazz = SiteController.class;

        System.out.println("Liste des URLs dans la classe " + clazz.getSimpleName() + " :");
        System.out.println("-------------------------------------------------------");

        for (Method method : clazz.getDeclaredMethods()) {
            if (method.isAnnotationPresent(HandleUrl.class)) {
                HandleUrl annotation = method.getAnnotation(HandleUrl.class);
                System.out.println("Méthode : " + method.getName() + " --> URL : " + annotation.value());
            }
        }
    }
}
