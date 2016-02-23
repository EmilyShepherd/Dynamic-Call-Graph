package q3.ams2g11;

import q3.B;

public class Main
{
	public static void main(String[] args)
	{
		B a = new B();

        for (int i = 0; i < 20; i++)
        {
            try
            {
                a.foo(i);
            }
            catch (Exception e) {}
        }	
	}
}
