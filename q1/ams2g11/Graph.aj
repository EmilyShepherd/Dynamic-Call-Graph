package q1.ams2g11;

import java.util.ArrayList;
import java.util.Stack;
import java.io.PrintWriter;

public aspect Graph
{
	pointcut q1PubCall() :  execution(public int q1..*(int));
	pointcut notStack()  : !call(* java.util.Stack.*(..));
	pointcut allCalls()  :  call(* *(..)) && notStack();
	pointcut inside()    :  within(q1..*);
	pointcut outside()   : !inside();

	private ArrayList nodes = new ArrayList();
	private ArrayList paths = new ArrayList();
	private Stack calls   = new Stack();
	private PrintWriter nodesWriter;
	private PrintWriter pathsWriter;

	before(): execution(public int q1..*(int))
	{
		if (!calls.empty() && calls.peek() != null)
		{
			add(calls.peek());
			add(thisJoinPoint.getSignature());
			add(calls.peek() + "," + thisJoinPoint.getSignature(), paths, pathsWriter);
		}

		calls.push(thisJoinPoint.getSignature());
	};

	private void add(Object item, ArrayList list, PrintWriter writer)
	{
		if (!list.contains(item))
		{
			list.add(item);
			writer.write(item + "\r\n");
		}
	}

	private void add(Object node)
	{
		add(node, nodes, nodesWriter);
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

	before(): execution(static void main(String[]))
	{
		try
		{
			nodesWriter = new PrintWriter("q1-nodes.csv", "UTF-8");
			pathsWriter = new PrintWriter("q1-edges.csv", "UTF-8");
		}
		catch (Exception e) {}
	}

	after(): execution(static void main(String[]))
	{
		try
		{
			nodesWriter.close();
			pathsWriter.close();
		}
		catch (Exception e) {}
	}
};
