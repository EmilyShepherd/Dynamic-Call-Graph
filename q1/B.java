package q1;

/**
 * Abstract test class
 */
public class B
{
	private int val;

	public B(int val)
	{
		this.val = val;
	}

	public int foo()
	{
		bar(1);
		return 0;
	}
	
	public int bar(int b)
	{
		return baz(b);
	}
	
	public int baz(int a)
	{
		return a + a;
	}
} 