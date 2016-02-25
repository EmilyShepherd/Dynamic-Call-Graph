package q2;

import test.TestingException;

public class B
{
	public int foo(int a)
	{
		bar(1);
		return 0;
	}
	
	public int bar(int b)
	{
		baz(b);

		if (b == 1) throw new TestingException();
		
		return baz(b);
	}
	
	public int baz(int a)
	{
		return a + a;
	}
} 