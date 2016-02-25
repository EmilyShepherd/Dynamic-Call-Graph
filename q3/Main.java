package q3;

import java.lang.StringBuilder;
import test.TestingException;

public class Main
{
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
