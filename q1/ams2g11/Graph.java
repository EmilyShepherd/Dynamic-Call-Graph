package q1.ams2g11;

import java.util.ArrayList;
import java.util.Stack;

public aspect Graph
{
	pointcut q1PubCall() :  execution(public int q1..*(int));
	pointcut notStack()  : !call(* java.util.Stack.*(..));
	pointcut allCalls()  :  call(* *(..)) && notStack();
	pointcut inside()    :  within(q1..*);
	pointcut outside()   : !inside();

	private ArrayList nodes = new ArrayList();
	private Stack calls   = new Stack();

	before(): execution(public int q1..*(int))
	{
		if (!calls.empty() && calls.peek() != null)
		{
			add(calls.peek());
			add(thisJoinPoint.getSignature().toString());
			System.out.println("Link: " + calls.peek() + "," + thisJoinPoint.getSignature().toString());
		}

		calls.push(thisJoinPoint.getSignature());
	};

	private void add(Object node)
	{
		if (!nodes.contains(node))
		{
			nodes.add(node);
		}
	}

	before(): allCalls() && !call(public int q1..*(int))
	{
		//System.out.println(thisJoinPoint.getSignature().toString());
		calls.push(null);
	};

	after(): (allCalls() && !call(public int q1..*(int))) || execution(public int q1..*(int))
	{
		if (!calls.empty())
		{
			calls.pop();
		}
	};
};
