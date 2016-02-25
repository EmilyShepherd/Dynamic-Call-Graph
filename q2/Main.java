package q2;

import test.TestingException;

/**
 * Test Harness for the q2 package
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
		B a = new B();

        try
        {
            a.foo(3);
        }
        catch (TestingException e) {}
	}
}
