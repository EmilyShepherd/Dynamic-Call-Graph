package q3.ams2g11;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.io.PrintWriter;
import java.io.FileNotFoundException;
import java.io.UnsupportedEncodingException;
import org.aspectj.lang.Signature;

/**
 * Holds details about a specific method
 */
class MethodDetails
{
    // {{{ Static

    /**
     * The list of all MethodDetails which have been created so far
     */
    private static HashMap methods = new HashMap();

    /**
     * Gets the correct MethodDetails instance for the given signature
     *
     * One one already exists, this is returned. Otherwise a new one is
     * created
     *
     * @param Signature signature The signature to use as an identifier
     * @return MethodDetails The correct instance
     */
    public static MethodDetails getInstance(Signature signature)
    {
        if (!methods.containsKey(signature))
        {
            methods.put(signature, new MethodDetails(signature));
        }

        return (MethodDetails)methods.get(signature);
    }

    /**
     * Returns the list of all methods which we have information about
     */
    public static HashMap getAll()
    {
        return methods;
    }

    // }}}


        ////////////////////////////////////////////////////////////


    // {{{ Object

    /**
     * The frequency histogram of input parameter values
     */ 
    private HashMap inFreqs    = new HashMap();

    /**
     * The frequency histogram of return values
     */ 
    private HashMap outFreqs   = new HashMap();

    /**
     * The list of runtimes for the method
     */
    private ArrayList runtimes = new ArrayList();

    /**
     * The number of times this method has failed
     *
     * A failure is defined as the method throwing an Exception
     */
    private int failures       = 0;

    /**
     * The mean runtime
     *
     * @see calculate()
     */
    private double mean;

    /**
     * The standard deviation of the runtime
     *
     * @see calculate()
     */
    private double sd;

    /**
     * The signature for the method
     */
    private Signature signature;

    /**
     * The file writer for this method's frequency histograms
     */
    private PrintWriter file;

    /**
     * Creates the method with the given signature
     *
     * This is private as the class uses the factory pattern. Use the static
     * getMethod() instead.
     *
     * @param Signature signature The signature for this method
     * @see getInstance()
     */
    private MethodDetails(Signature signature)
    {
        this.signature = signature;
    }

    /**
     * Records a failured run of the method
     */
    public void addFailure()
    {
        failures++;
    }

    /**
     * Gets the frequency of failures for this method
     *
     * @return double The frequency of failures
     */
    public double getFailFreq()
    {
        return (double)failures / (double)runtimes.size() * 100;
    }

    /**
     * Adds an input parameter value
     *
     * @param int in The parameter value
     */
    public void addIn(int in)
    {
        add(in, inFreqs);
    }

    /**
     * Adds a return value
     *
     * @param int out The return value
     */
    public void addOut(int out)
    {
        add(out, outFreqs);
    }

    /**
     * Adds a runtime for a run of the method
     *
     * @param Long time The runtime
     */
    public void addRuntime(Long time)
    {
        runtimes.add(time);
    }

    /**
     * Adds a value to one of the frequency histograms
     *
     * If the value exists in the histogram, its frequency is incremented
     * by one. Otherwise it is initialised to one.
     *
     * @param int val The value to add
     * @param HashMap freqs The histogram to add the value to
     */
    private void add(int val, HashMap freqs)
    {
        Integer key = Integer.valueOf(val);
        int freq    = 1;

        // If it exists, get the value and incrememnt it
        if (freqs.containsKey(key))
        {
            freq = 1 + ((Integer)freqs.get(key)).intValue();
        }

        freqs.put(key, Integer.valueOf(freq));
    }

    /**
     * Calculate the mean and standard deviation of the method runtimes
     */
    public void calculate()
    {
        Iterator it  = runtimes.iterator();
        long sumX     = 0;
        long sumXSqrd = 0;

        // Loop over the values, calculating SUM(x) and SUM(x^2)
        while (it.hasNext())
        {
            long x     = ((Long)it.next()).longValue();

            sumX     += x;
            sumXSqrd += x * x;
        }

        // Mean = SUM(x) / n
        mean = sumX / runtimes.size();

        // SD^2 = ( SUM(X^2) - SUM(x)^2 / n ) / ( n - 1 )
        sd   = Math.sqrt((sumXSqrd - mean * sumX) / (runtimes.size() - 1));

    }

    /**
     * Gets the mean runtime
     *
     * Must have been calculated by calculate()!
     *
     * @return double The mean runtime
     * @see calculate()
     */
    public double getMean()
    {
        return mean;
    }

    /**
     * Gets the standard deviation of the runtime
     *
     * Must have been calculated by calculate()!
     *
     * @return double The standard deviation of the runtime
     * @see calculate()
     */
    public double getStandardDeviation()
    {
        return sd;
    }

    /**
     * Saves the frequency histograms for this method
     */
    public void save()
    {
        try
        {
            file = new PrintWriter(signature + "-hist.csv", "UTF-8");

            saveFreqs(inFreqs,  "param");
            saveFreqs(outFreqs, "return");

            file.close();
        }
        catch (FileNotFoundException e)
        {
            throw new RuntimeException("File not writable");
        }
        catch (UnsupportedEncodingException e)
        {
            throw new RuntimeException("UTF8 not supported");
        }
    }

    /**
     * Saves the given frequency histogram
     *
     * @param HashMap freqs The histogram to save
     * @param String type The identifier to use in the CSV
     */
    private void saveFreqs(HashMap freqs, String type)
    {
        Iterator it = freqs.entrySet().iterator();

        while (it.hasNext())
        {
            Map.Entry entry = (Map.Entry)it.next();

            file.println(type + "," + entry.getKey() + "," + entry.getValue());
        }
    }
}