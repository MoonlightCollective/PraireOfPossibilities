
import java.lang.Math;
import java.util.Random;

// class to capture a bunch of simple functions we use a lot.
public static class PrairieUtils {
	public static Random rand = new Random();
	public static boolean IsInner(int pointDex) { return(pointDex%7 < 2); }
	public static boolean IsOuter(int pointDex) { return(pointDex%7 > 1); }

	public static final int kNumLightsPerPlant = 7;

	public static int RandomPlantDex(int modelSize)
	{
	    return rand.nextInt(modelSize/kNumLightsPerPlant);
	}

	public static int RandomInRange(int lower, int upper)
	{
		return rand.nextInt((upper - lower) + 1) + lower;
	}
}

public static class PrairieEnvAD
{
	public boolean IsActive;
	public double AttackTimeMs;
	public double DecayTimeMs;
	public float CurVal;

	private double envTimer;
	private double totalTimeMs;

	public PrairieEnvAD(double attackTimeMs, double decayTimeMs)
	{
		CurVal = 0;
		IsActive = false;
		AttackTimeMs = attackTimeMs;
		DecayTimeMs = decayTimeMs;
		envTimer = 0;
		totalTimeMs = AttackTimeMs + DecayTimeMs;
	}

	public void Update(double updateMs)
	{
		totalTimeMs = AttackTimeMs + DecayTimeMs; // compute this each update since it might have changed.  Could be more efficient with dirty bits.
		// println("envUpdateA:" + envTimer + "/" + totalTimeMs+ "(" + updateMs + ")");
		if (IsActive) {
			envTimer = Math.min(envTimer + updateMs,totalTimeMs);
			// println("envUpdateB:" + envTimer + "/" + totalTimeMs);

			if (envTimer >= totalTimeMs) {
				IsActive = false;
				CurVal = 0;
			}
			else {
				if (envTimer <= AttackTimeMs) {
					CurVal = (float)(envTimer / AttackTimeMs);
				}
				else {
					CurVal = (float)(1 - (envTimer - AttackTimeMs) / DecayTimeMs);
				}
			}
		}
	}

	public void Trigger(boolean retrig)
	{
		if (retrig || !IsActive)
		{
			IsActive = true;
			
			if (IsActive && !retrig) // if we are in the middle of an envelope, then we don't want to reset
				envTimer = CurVal * AttackTimeMs; // fast forward in the envelope to catch up to our current (normalized) value
			else
				envTimer = 0;
			
			CurVal = 0;
		}
	}


}