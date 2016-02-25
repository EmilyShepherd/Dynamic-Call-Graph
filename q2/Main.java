package q2;

import test.TestingException;

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
