package q3;

import java.lang.StringBuilder;
import test.TestingException;

/**
 * Test Harness for the q3 package
 */
public class Main
{
    /**
     * Fake main method to be woven by the test AspectJ files
     *
     * @param String[] args This method doesn't accept any arguments
     */
	public static void main(String[] args)
	{
        System.out.println("Testing Question 3");

		B a = new B();

        for (int i = 0; i < 20; i++)
        {
            System.out.print("[" + repeat("#", i) + repeat(" ", 19 - i) + "]\r");

            try
            {
                a.foo(i);
            }
            catch (TestingException e) {}
        }	
	}

    /**
     * Repeats the given string
     *
     * Used by the console progress bar
     *
     * @param String s The string to repeat
     * @param int n The number of times to repeat it
     * @return String The string, repeated n times
     */
    private static String repeat(String s, int n)
    {
        StringBuilder sb = new StringBuilder();

        for (int i = 0; i < n; i++)
        {
            sb.append(s);
        }

        return sb.toString();
    }
}
