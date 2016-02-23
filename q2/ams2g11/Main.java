package q2.ams2g11;

import q2.B;
import q2.TestingException;

public class Main
{
	public static void main(String[] args)
	{
		B a = new B();

        try
        {
            a.foo(3);
        }
        catch (TestingException e) {}
	}
}
