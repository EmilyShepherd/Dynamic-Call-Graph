package q1.ams2g11;

import java.util.ArrayList;
import java.util.Stack;
import java.io.PrintWriter;

public aspect Graph
{
	pointcut node()     : execution(public int q1..*(int));
	pointcut nodeCall() : call(public int q1..*(int));
	pointcut stack()    : call(* java.util.Stack.*(..));
	pointcut allCalls() : call(* *(..)) && !stack() && !nodeCall();
	pointcut inside()   : within(q1..*);
	pointcut main()     : execution(static void main(String[]));

	private ArrayList nodes = new ArrayList();
	private ArrayList paths = new ArrayList();
	private Stack calls   = new Stack();
	private PrintWriter nodesWriter;
	private PrintWriter pathsWriter;

	before(): node()
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

	before(): allCalls()
	{
		calls.push(null);
	};

	after(): allCalls() || node()
	{
		if (!calls.empty())
		{
			calls.pop();
		}
	};

	before(): main()
	{
		try
		{
			nodesWriter = new PrintWriter("q1-nodes.csv", "UTF-8");
			pathsWriter = new PrintWriter("q1-edges.csv", "UTF-8");
		}
		catch (Exception e) {}
	}

	after(): main()
	{
		try
		{
			nodesWriter.close();
			pathsWriter.close();
		}
		catch (Exception e) {}
	}
};
