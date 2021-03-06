package q2.ams2g11;

import java.util.ArrayList;
import java.util.Stack;
import java.io.PrintWriter;
import java.io.FileNotFoundException;
import java.io.UnsupportedEncodingException;
import org.aspectj.lang.Signature;

public aspect Graph
{
    /**
     * Register a node at the beginning of its execution
     */
    pointcut node()     : execution(public int q2..*(int));
    
    /**
     * Before a node is called
     */
    pointcut nodeCall() : call(public int q2..*(int));

    /**
     * Calls to Java's Stack object
     *
     * We use this to exclude Stack calls from allCalls() to avoid infinate
     * loops. This is safe because we know there's no way that java.util.Stack
     * will ever call anything in q2..* (unless you deliberately compile a new
     * version in just to be difficult, in which case, dammit)
     */
    pointcut stack()    : call(* java.util.Stack.*(..));

    /**
     * Matches when code is running within q2..*
     *
     * We use this to ensure we don't edit code outside of the namespace. This
     * doesn't really matter (the code will function without this check) however
     * amending third party stuff is a bit of a waste of time.
     */
    pointcut inside()   : within(q2..*);
    
    /**
     * All calls that aren't nodes (and stack calls)
     *
     * These are used to register the fact that we are no longer within a node,
     * so when a node is next operated, this won't count as a link
     */
    pointcut allCalls() : inside() && call(* *(..)) && !stack() && !nodeCall();

    /**
     * Set of nodes
     */
    private ArrayList nodes = new ArrayList();
    
    /**
     * Set of edges
     */
    private ArrayList paths = new ArrayList();
    
    /**
     * Stack of method calls
     *
     * We store this to keep track of the calling method when a node is executed
     * so we know if its a direct link or not
     */
    private Stack calls   = new Stack();
    
    /**
     * File Writer for the nodes CSV
     */
    private PrintWriter nodesWriter;
    
    /**
     * File Writer for the edges CSV
     */
    private PrintWriter pathsWriter;
    
    /**
     * Init the file writers
     *
     * @throws FileNotFoundException If the Working Directory is write protected
     * @throws UnsupportedEncodingException If UTF-8 isn't supported
     */
    Graph() throws FileNotFoundException, UnsupportedEncodingException
    {
        nodesWriter = new PrintWriter("q2-nodes.csv", "UTF-8");
        pathsWriter = new PrintWriter("q2-edges.csv", "UTF-8");
    }

    /**
     * Run this before a node is executed
     *
     * If the calling method is also a node, we'll register this as a link
     */
    before(): node()
    {
        // Let's record ourselves as the current method
        calls.push(thisJoinPoint.getSignature());
    };

    /**
     * Adds an element to a Set if it does not already exist
     *
     * @param Object item The element to attempt to add
     * @param ArrayList list The set to add it to
     * @param PrintWriter writer The writer to use if the element should be added
     */
    private void add(Object item, ArrayList list, PrintWriter writer)
    {
        if (!list.contains(item))
        {
            list.add(item);
            writer.write(item + "\r\n");
            writer.flush();
        }
    }

    /**
     * Adds a node to the set of nodes if it does not already exist
     *
     * @param Object node The node to attempt to add
     * @see add(Object, ArrayList, PrintWriter)
     */
    private void add(Object node)
    {
        add(node, nodes, nodesWriter);
    }

    /**
     * Before all other calls, register that we aren't in a node anymore
     */
    before(): allCalls()
    {
        // All we care is that we aren't in a node, so we don't need to
        // actually store any information about the current method.
        // Therefore, NULL is acceptable.
        calls.push(null);
    };

    /**
     * After all calls, pop the stack
     *
     * This is used to return to the previous calling method (it also also
     * run after the execution of a node).
     */
    after(): allCalls()
    {
        // It is possible for the call stack to be empty, if a node is called
        // from outside the q2 package
        if (!calls.empty())
        {
            calls.pop();
        }
    };

    /**
     * If a node throws an error, we should simply pop it from the stack and
     * ignore it
     */
    after() throwing: node()
    {
        calls.pop();
    }

    /**
     * If the node returns as expected, then we will handle it as we did in q1
     */
    after() returning: node()
    {
        // Slightly different from Q1, because this is executing after the node
        // execution, we have to pop that off the stack first.
        Signature node = (Signature)calls.pop();

        // Check the stack for the previous call
        if (node != null && !calls.empty() && calls.peek() != null)
        {
            // Add the nodes if we haven't already
            add(calls.peek());
            add(node);

            // Add the link if we haven't already
            add(calls.peek() + "," + node, paths, pathsWriter);
        }
    }
};
