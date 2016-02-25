package test;

import java.lang.Class;
import java.lang.reflect.Method;

/**
 * Runs the tests on the given question
 */
public class TestHarness
{
    /**
     * The main method
     *
     * @param String[] args Arguemtn 1 should be q1|q2|q3
     */
    public static void main(String[] args) throws Exception
    {
        Class c  = Class.forName(args[0] + ".Main");
        Object o = c.newInstance();

        call("main", c, o);
        //call("test", c, o);
    }

    /**
     * Calls the given method on the given object
     *
     * @param String method The name of the method to call
     * @param Class c The class description
     * @param Object o The instance of the object
     */
    private static void call(String method, Class c, Object o) throws Exception
    {
        for (Method m : c.getDeclaredMethods())
        {
            if (m.getName().equals(method))
            {
                m.invoke(o, (Object)null);
            }
        }
    }
}