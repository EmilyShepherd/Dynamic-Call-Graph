
import java.lang.Class;
import java.lang.reflect.Method;

public class TestHarness
{
    public static void main(String[] args) throws Exception
    {
        Class c = Class.forName(args[0] + ".Main");
        Method[] allMethods = c.getDeclaredMethods();

        for (Method m : allMethods)
        {
            if (m.getName().equals("main"))
            {
                m.invoke(c.newInstance(), (Object)null);
            }
        }
    }
}