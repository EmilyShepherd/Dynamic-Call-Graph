package q3.ams2g11;

import java.util.Stack;
import java.util.Iterator;
import java.util.Map;
import java.io.PrintWriter;
import java.io.FileNotFoundException;
import java.io.UnsupportedEncodingException;
import org.aspectj.lang.Signature;
import org.aspectj.lang.JoinPoint;

public aspect Graph
{
    /**
     * Register a node at the beginning of its execution
     */
    pointcut node(int in) : execution(public int q3..*(int)) && args(in);
    
    /**
     * Before a node is called
     */
    pointcut nodeCall() : call(public int q3..*(int));

    /**
     * Calls to Java's Stack object and this object
     *
     * We use this to exclude Stack calls from allCalls() to avoid infinate
     * loops. This is safe because we know there's no way that java.util.Stack
     * will ever call anything in q3..* (unless you deliberately compile a new
     * version in just to be difficult, in which case: ...dammit).
     *
     * We also need to exclude callerIsNode() which is called after the execution
     * of a node - this manipulates the stack, so expects it to be untainted by
     * its own invocation.
     */
    pointcut internal()    : call(* java.util.Stack.*(..)) || call(* q3.ams2g11.Graph.callerIsNode(..));

    /**
     * Matches when code is running within q3..*
     *
     * We use this to ensure we don't edit code outside of the namespace. This
     * doesn't really matter (the code will function without this check) however
     * amending third party stuff is a bit of a waste of time.
     */
    pointcut inside()   : within(q3..*);
    
    /**
     * All calls that aren't nodes (and stack calls)
     *
     * These are used to register the fact that we are no longer within a node,
     * so when a node is next operated, this won't count as a link
     */
    pointcut allCalls() : inside() && call(* *(..)) && !internal() && !nodeCall();

    /**
     * Stack of method calls
     *
     * We store this to keep track of the calling method when a node is executed
     * so we know if its a direct link or not
     */
    private Stack calls   = new Stack();
    
    /**
     */
    private PrintWriter failuresWriter;
    
    /**
     */
    private PrintWriter runtimesWriter;

    private MethodDetails thisMethodDetails;
    
    /**
     * Init the file writers
     *
     * @throws FileNotFoundException If the Working Directory is write protected
     * @throws UnsupportedEncodingException If UTF-8 isn't supported
     */
    Graph() throws FileNotFoundException, UnsupportedEncodingException
    {
        failuresWriter = new PrintWriter("failures.csv", "UTF-8");
        runtimesWriter = new PrintWriter("runtimes.csv", "UTF-8");
    }

    /**
     * Run this before a node is executed
     *
     * If the calling method is also a node, we'll register this as a link
     */
    before(int in): node(in)
    {
        // Let's record ourselves as the current method.
        // This differs from the previous questions in that we are now using
        // the stack to only only store the boolean value of whether or not we
        // are in a node, but also the start time so we can work out its total
        // runtime later.
        calls.push(Long.valueOf(System.currentTimeMillis()));

        // Record this in value
        MethodDetails.getInstance(thisJoinPoint.getSignature()).addIn(in);
    };

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
        // from outside the q3 package
        if (!calls.empty())
        {
            calls.pop();
        }
    };

    /**
     * If a node throws an error, we should make a note of this
     */
    after(int in) throwing: node(in)
    {
        if (callerIsNode(thisJoinPoint))
        {
            thisMethodDetails.addFailure();
        }
    }

    /**
     * If the node returns as expected, then we make a note of its returned
     * value
     */
    after(int in) returning(int ret): node(in)
    {
        if (callerIsNode(thisJoinPoint))
        {
            thisMethodDetails.addOut(ret);
        }
    }

    private boolean callerIsNode(JoinPoint jp)
    {
        // AspectJ seems to default to source level 1.4 for some mad reason,
        // which makes autoboxing not a thing :'(
        // This is fixable by passing the -source 1.8 flag to the AJcompiler,
        // but I cba to take the risk that your test script doesn't do that.
        long start = ((Long)calls.pop()).longValue();
        long end   = System.currentTimeMillis();

        // Caller ain't a node, we can ignore this
        if (false && (calls.empty() || calls.peek() == null))
        {
            return false;
        }
        // Caller is a node, add its run time then return true
        else
        {
            thisMethodDetails = MethodDetails.getInstance(jp.getSignature());

            thisMethodDetails.addRuntime(new Long(end - start));

            return true;
        }
    }

    after(): execution(public static void main(String[]))
    {

        Iterator it = MethodDetails.getAll().entrySet().iterator();

        while (it.hasNext())
        {
            Map.Entry entry  = (Map.Entry)it.next();
            MethodDetails md = (MethodDetails)entry.getValue();
            md.calculate();
            md.save();

            failuresWriter.println(entry.getKey() + "," + md.getFailFreq());
            runtimesWriter.println(entry.getKey() + "," + md.getMean() + "," + md.getStandardDeviation());
        }

        failuresWriter.close();
        runtimesWriter.close();
    }
};
