package q1;

/**
 * Test Harness for the q1 package
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
		A a = new A();

        a.foo(3);
	}
}
