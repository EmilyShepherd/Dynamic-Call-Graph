package q3;

import test.TestingException;

public class B
{
	public int foo(int a)
	{
		if (a % 3 == 0) bar(a);
		else baz(a);

		return 0;
	}
	
	public int bar(int b)
	{
		if (b % 2 == 0) throw new TestingException();
		
		return baz(b);
	}
	
	public int baz(int a)
	{
		a = a % 7;

		for (int i = 0; i < a * a; i++)
		{
			try
			{
				Thread.sleep(200);
			}
			catch (Exception e) {}
		}
		return a + a;
	}
} 