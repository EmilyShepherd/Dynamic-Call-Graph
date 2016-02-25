package q1;

/**
 * Abstract test class
 */
public class A
{
	public int foo(int a)
	{
		return bar() + baz(a * 2);
	}

	private int bar()
	{
		return baz(4);
	}
	
	public int baz(int a)
	{
		B b = new B(a);

		return b.foo() + b.bar(a);
	}
} 