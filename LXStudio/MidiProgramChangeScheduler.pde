import java.nio.file.Paths;


// This class listens for MIDI program change events. If a program change event occurs on 
// any Midi channel, it will look to see if the Project Scheduler is enabled in LX.Studio.
// If the scheduler _is_ enabled, then it will look through the projects for a file with a name
// that matches the program change requested.  For name matching, we look for a pair of
// numbers in paremtheses anywhere in the file name, separated by a dash. e.g. MyProjectFile(2-12).lxp
//
// The first number is the midi channel, and the second is the program change number in the event.
// So, if we sent a Program Change: 12 on Midi Channel 2, then it will load the project in the example above,
// but ONLY if the scheduler is enabled in LX Studio.
//
// Some additional logic is in here to prevent re-loading the same project multiple times. Some midi files
// might fire the same program change event more than ones, and we don't want to trigger more loads
// than we need to.
public class MidiProgramChangeListener implements LXMidiListener, LX.ProjectListener
{
	LXScheduler sched;
	LXMidiEngine midiEngine;
	private int curEntryProgram = -1;
	private int curEntryChannel = -1;
	LX lx;

	public MidiProgramChangeListener(LX lxIn)
	{
		sched = lxIn.scheduler;
		lx = lxIn;
		resetState();
		lx.addProjectListener(this);
	}

	// lX.ProjectListner implementation
	public void projectChanged(File file, LX.ProjectListener.Change change)
	{
		if (change == LX.ProjectListener.Change.OPEN || change == LX.ProjectListener.Change.NEW)
		{
			println("MPCL: New project open: " + file.toString());
			if (curEntryChannel < 0 || curEntryProgram < 0)
			{
				println("MPCL: changed - resetting MPCL state");
				resetState();
			}
			else
			{
				String fName = file.toString();
				int ch = chFromFileName(fName);
				int pc = pcFromFileName(fName);
				if (ch == curEntryChannel && pc == curEntryProgram)
				{
					println("MPCL: Channel and program match what's loaded, not restting state");
				}
				else
				{
					println("MPCL: Chanel " + ch + "or Program " + pc + "don't match current schedule selection (" + curEntryChannel + "," + curEntryProgram + ") - resetting state");
					resetState();
				}
			}
		}
	}

	private void resetState()
	{
		curEntryChannel = -1;
		curEntryProgram = -1;
	}
	// LXMidiListener interface
	public void programChangeReceived(MidiProgramChange pc)
	{
		String pcStr = "(" + (pc.getChannel() + 1) + "-" + pc.getProgram() + ")";
		println("MPCL: Program change " + pcStr);

		if (sched == null)
		{
			println("\tNo scheduler - ignoring");
			return;
		}

		if (sched.entries.size() < 1)
		{
			println("\tNo scheduled projects - ignoring");
			return;
		}

		if (sched.isInTransition())
		{
			println("\tAlready in transition - ignoring");
			return;
		}

		if (!sched.enabled.getValueb())
		{
			println("\tSchedule not enabled - ignoring");
			return;
		}

		for (LXScheduledProject e : sched.entries)
		{
			String entryStr = e.projectFile.getString();
			if (entryStr.contains(pcStr))
			{
				int newDex = e.getIndex();
				int newCh = chFromFileName(entryStr);
				int newPc = pcFromFileName(entryStr);

				if (newCh == curEntryChannel && newPc == curEntryProgram)
				{
					println("\tProject matching that request already open - ignoring");
					return;
				}
				else
				{
					println("\tOpening scheduled project:" + entryStr);
					curEntryProgram = newPc;
					curEntryChannel = newCh;
					e.open();
				}
			}
		}
	}


	int chFromFileName(String fileName)
	{
		println("chFromFilename:" + fileName);
		
		if (!fileName.contains("(") || !fileName.contains("-"))
		{
			return -1;
		}
		int chDex = fileName.indexOf("(") + 1;
		int dashDex = fileName.indexOf("-");
		int ch = Integer.parseInt(fileName.substring(chDex,dashDex));
		return ch;
	}

	int pcFromFileName(String fileName)
	{
		println("pcFromFilename:" + fileName);
		if (!fileName.contains(")") || !fileName.contains("-"))
		{
			return -1;
		}
		int dashDex = fileName.indexOf("-");
		int endDex = fileName.indexOf(")");
		int pc = Integer.parseInt(fileName.substring(dashDex+1,endDex));
		return pc;
	}

}