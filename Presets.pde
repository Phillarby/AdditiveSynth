/*
Presets are defined in this class.  Preset standard is a base class, and a number of classes further down derrive from this.
Once a preset class is defined, it must be added to to the presets array in the setup method of the main class
*/

public class PresetStandard implements IWavePreset
{
  //Arrays to hold default values
  private float[] _overtone;
  private float[] _amplitude;
  private float[] _delay;
  private float[] _leftAmplitudeFactor;
  private float[] _rightAmplitudeFactor;
  private boolean[] _effectDelay;
  private boolean[] _effectAmplitude;
  private boolean[] _isActive; 
  
  private String _summary = "A single sine wave at the base frequency  without any additional processing. This is a good starting point for your own experiments with the waves.\n\n" + 
                            "All presets are intended as starting points for experiementation with the principles of audio perception.  The real fun comes from playing with the " +
                            "parameters once presets are applied and seeing how they affect the output";
  private float _xPosition = 1;
  private String _dropdownLabel = "Additive Synthesis: Basic Sine Wave";
  
  public PresetStandard()
  {
    setAmplitude(new float[] {1, 0, 0, 0, 0, 0, 0, 0, 0, 0});
    setDelay(new float[] {0, 0, 0, 0, 0, 0, 0, 0, 0, 0});
    setOvertone(new float[] {1, 1, 1, 1, 1, 1, 1, 1, 1, 1});
    setEffectDelay(new boolean[] {false, false, false, false, false, false, false, false, false, false});
    setEffectAmplitude(new boolean[] {false, false, false, false, false, false, false, false, false, false});
    setIsActive(new boolean[] {true, false, false, false, false, false, false, false, false, false});
    setLeftAmplitudeFactor(new float[] {1, 1, 1, 1, 1, 1, 1, 1, 1, 1});
    setRightAmplitudeFactor(new float[] {1, 1, 1, 1, 1, 1, 1, 1, 1, 1});
  }
  
  //Encapsulating public methods  
  public float getAmplitude(int index)
  {
    return _amplitude[index];
  }
  public void setAmplitude(float[] amplitudeArray)
  {
    _amplitude = amplitudeArray;
  }
  
  public float getDelay(int index)
  {
    return _delay[index];
  }
  public void setDelay(float[] delayArray)
  {
    _delay = delayArray;
  }
  
  public boolean getEffectDelay(int index)
  {
    return _effectDelay[index];
  }
  public void setEffectDelay(boolean[] effectDelayArray)
  {
    _effectDelay = effectDelayArray;
  }
  
  public boolean getEffectAmplitude(int index)
  {
    return _effectAmplitude[index];
  }
  public void setEffectAmplitude(boolean[] effectAmplitudeArray)
  {
    _effectAmplitude = effectAmplitudeArray;
  }
  
  public boolean getIsActive(int index)
  {
    return _isActive[index];
  }
  public void setIsActive(boolean[] isActiveArray)
  {
    _isActive = isActiveArray;
  }
  
  public float getOvertone(int index)
  {
    return _overtone[index];
  }
  public void setOvertone(float[] overtoneArray)
  {
    _overtone = overtoneArray;
  }
  
  public float getXPosition()
  {
    return _xPosition;
  }
  
  public String getSummary()
  {
    return _summary;
  }
  public void setSummary(String summaryText)
  {
    _summary = summaryText;
  }
  
  public String getDropdownLabel()
  {
    return _dropdownLabel;
  }
  public void setDropdownLabel(String labelText)
  {
      _dropdownLabel = labelText;
  }
  
  public float getLeftAmplitudeFactor(int index)
  {
    return _leftAmplitudeFactor[index];
  }
  public void setLeftAmplitudeFactor(float[] leftAmplitudeFactorArray)
  {
    _leftAmplitudeFactor = leftAmplitudeFactorArray;
  }
  
  public float getRightAmplitudeFactor(int index)
  {
    return _rightAmplitudeFactor[index];
  }
  public void setRightAmplitudeFactor(float[] rightAmplitudeFactorArray)
  {
    _rightAmplitudeFactor = rightAmplitudeFactorArray;
  }
}

public class PresetInharmonic extends PresetStandard
{
  public PresetInharmonic()
  {
    setDropdownLabel("Additive Synthesis: Inharmonic waves");
    setSummary("When combining waveforms that are not of the same harmonic series e.g. the freqeuncies are not intergeger multiples " +
      "of the base frequency; a rhythm is created as the waves go in and out of phase with each other.  The pace of the rhythm is  " +
      "determined by the regularlity of this phasing. This is best visualised using the live output setting.\n\nThis can be " +
      "demonstrated by enabling and disabling diffent waves to see how the rhythm is affected.  Please note that the overtone "+
      "values applied in this preset are not selectable through the usual controls so if you change them they will revert back " +
      "to integers");
    setOvertone(new float[] {1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 1.9, 2});
    setAmplitude(new float[] {0.4, 0.3, 0.15, 0.075, 0.0375, 0.01875, 0.009375, 0.0046875234375, 0.001171875, 0.0005859375});
    setDelay(new float[] {0, 0, 0, 0, 0, 0, 0, 0, 0, 0});
    setEffectDelay(new boolean[] {true, true, true, true, true, true, true, true, true, true});
    setEffectAmplitude(new boolean[] {false, false, false, false, false, false, false, false, false, false});
    setIsActive(new boolean[] {true, true, true, true, true, true, true, true, true, true});
    setLeftAmplitudeFactor(new float[] {1, 1, 1, 1, 1, 1, 1, 1, 1, 1});
    setRightAmplitudeFactor(new float[] {1, 1, 1, 1, 1, 1, 1, 1, 1, 1});
    super._xPosition = 1;
  }
}

public class PresetSawWave extends PresetStandard
{
  public PresetSawWave()
  {
    setDropdownLabel("Additive Synthesis: Saw Wave");
    setSummary("By combining multiple sine waves it is theoretically possible to create any repetative waveform.\n\n" +
      "A saw wave consists of a sine wave and all it's harmonic overtones.  " +
      "In this preset only the first five overtones are being applied, but it does demonstrate the principle. "+
      "Adding more overtones would increase the definition of the wave\n\nIt becomes clear how this wave is " +
      "composed if you try adjusting the intensity of various wave components");
    setOvertone(new float[] {1, 2, 3, 4, 5, 6, 7, 8, 9, 10});
    setAmplitude(new float[] {0.75, 0.3, 0.15, 0.07, 0.03, 0.01, 0.00, 0.001, 0.001, 0.001});
    setDelay(new float[] {0, 0, 0, 0, 0, 0, 0, 0, 0, 0});
    setEffectDelay(new boolean[] {true, true, true, true, true, true, true, true, true, true});
    setEffectAmplitude(new boolean[] {false, false, false, false, false, false, false, false, false, false});
    setIsActive(new boolean[] {true, true, true, true, true, true, true, false, false, false});
    setLeftAmplitudeFactor(new float[] {1, 1, 1, 1, 1, 1, 1, 1, 1, 1});
    setRightAmplitudeFactor(new float[] {1, 1, 1, 1, 1, 1, 1, 1, 1, 1});
    super._xPosition = 1;
  }
}

public class PresetOvertones extends PresetStandard
{
  public PresetOvertones()
  {
    setDropdownLabel("Gestalt Grouping: Harmonic Overtones");
    setSummary("Gestalt principles of grouping can be experienced through timbre by " +
      "disabling and then re-enabling individual wave component.\n\n" +
      "If you perecive this effect, you will initially hear the 4 waves as one grouped sound. Once " +
      "an individual component wave has been stopped and resarted you should perceive two distinct " +
      "sounds simultaneously. Although the final wave is the same, the experience is very different" +
      "It can be useful to select the silence preset before this one to 'reset' you hearing");
    setOvertone(new float[] {2, 3, 4, 5, 6, 7, 8, 1, 1, 1});
    setAmplitude(new float[] {0.3, 0.3, 0.2, 0.1, 0, 0, 0, 0, 0, 0});
    setDelay(new float[] {0, 0, 0, 0, 0, 0, 0, 0, 0, 0});
    setEffectDelay(new boolean[] {false, false, false, false, false, false, false, false, false, false});
    setEffectAmplitude(new boolean[] {false, false, false, false, false, false, false, false, false, false});
    setIsActive(new boolean[] {true, true, true, true, false, false, false, false, false, false});
    setLeftAmplitudeFactor(new float[] {1, 1, 1, 1, 1, 1, 1, 1, 1, 1});
    setRightAmplitudeFactor(new float[] {1, 1, 1, 1, 1, 1, 1, 1, 1, 1});
    super._xPosition = 1;
  }
}

public class PresetPolyrhythm extends PresetStandard
{
  public PresetPolyrhythm()
  {
    setDropdownLabel("Gestalt Multistability: Polyrhythm");
    setSummary("This preset is playing different rhythm in each channel and is is best visualised using the live output setting. Gestalt principles of multistability state that the listener should only be able  " +
      "perceive one rhythm at a time, but should be able to switch between the two stable perception states in a manner similar to the two stable visual interpretations of a " +
      "necker cube.\n\nEach rhythm can be isolated by setting the position slider to the left or right extremes. If you manage to switch between the two states then try the same " +
      "on the polyrhythm equal preset.");
    setOvertone(new float[] {1.0, 1.05, 2.0, 2.05, 2, 2.0, 2.021, 3.0, 3.021, 1});
    setAmplitude(new float[] {0.2, 0.2, 0.2, 0.2, 0.1, 0.2, 0.2, 0.2, 0.2, 0.1});
    setDelay(new float[] {0.5, 0.5, 0.5, 0, 0, 0, 0, 0, 0, 0});
    setEffectDelay(new boolean[] {false, false, false, false, false, false, false, false, false, false});
    setEffectAmplitude(new boolean[] {true, true, true, true, true, true, true, true, true, true});
    setIsActive(new boolean[] {true, true, true, true, false, true, true, true, true, false});
    setLeftAmplitudeFactor(new float[] {1, 1, 1, 1, 1, 0, 0, 0, 0, 0});
    setRightAmplitudeFactor(new float[] {0, 0, 0, 0, 0, 1, 1, 1, 1, 1});
    super._xPosition = 1;
  }
}

public class PresetPolyrhythmEqual extends PresetStandard
{
  public PresetPolyrhythmEqual()
  {
    setDropdownLabel("Gestalt Multistability: Equal Polyrhythm");
    setSummary("This preset has the same wave parameters as the polyrhythm preset, but the levels are " +
               "equal in both channels.\n\nCan you identify the two independent rhythms? ");
    setOvertone(new float[] {1.0, 1.05, 2.0, 2.05, 1, 2.0, 2.021, 3.0, 3.021, 1});
    setAmplitude(new float[] {0.2, 0.2, 0.2, 0.2, 0.1, 0.2, 0.2, 0.2, 0.2, 0.1});
    setDelay(new float[] {0.5, 0.5, 0.5, 0, 0, 0, 0, 0, 0, 0});
    setEffectDelay(new boolean[] {false, false, false, false, false, false, false, false, false, false});
    setEffectAmplitude(new boolean[] {true, true, true, true, true, true, true, true, true, true});
    setIsActive(new boolean[] {true, true, true, true, false, true, true, true, true, false});
    setLeftAmplitudeFactor(new float[] {1, 1, 1, 1, 1, 1, 1, 1, 1, 1});
    setRightAmplitudeFactor(new float[] {1, 1, 1, 1, 1, 1, 1, 1, 1, 1});
    super._xPosition = 1;
  }
}

public class PresetPositionBoth extends PresetStandard
{
  public PresetPositionBoth()
  {
    setDropdownLabel("Positioning: Combined ITD and IID");
    setSummary("The positioning effect is strongest when ITD is applied to lower frequencies and IID to higher frequencies.\n\n" +
      "This is demonstrated in this preset using waves with a number of harmonic overtones with individual positioning properties " );
    setOvertone(new float[] {1, 2, 3, 4, 5, 6, 7, 1, 1, 1});
    setAmplitude(new float[] {0.4, 0.3, 0.3, 0.2, 0, 0, 0, 0, 0, 0});
    setDelay(new float[] {0, 0, 0, 0, 0, 0, 0, 0, 0, 0});
    setEffectDelay(new boolean[] {true, true, false, false, false, false, false, false, false, false});
    setEffectAmplitude(new boolean[] {false, true, true, true, false, false, false, false, false, false});
    setIsActive(new boolean[] {true, true, true, true, false, false, false, false, false, false});
    setLeftAmplitudeFactor(new float[] {1, 1, 1, 1, 1, 1, 1, 1, 1, 1});
    setRightAmplitudeFactor(new float[] {1, 1, 1, 1, 1, 1, 1, 1, 1, 1});
    super._xPosition = 1;
  }
}

public class PresetRhythm extends PresetStandard
{
  public PresetRhythm()
  {
    setDropdownLabel("Additive Synthesis: Inharmonic Rhythm");
    setSummary("Adding higer order inharmonic overtones to this wave has created a more intersting timbre than the basic inharmoic preset " +
      "with a very solid rhythm caused by the phasing of the wave.\n\nInterestingly, I find positioning particularly effective on this preset.");
    setOvertone(new float[] {1.0, 1.05, 2.1, 2.15, 3.2, 3.25, 1.3, 1.35, 1.4, 1.45});
    setAmplitude(new float[] {0.2, 0.2, 0.2, 0.2, 0.1, 0.1, 0.4, 0.4, 0.4, 0.4});
    setDelay(new float[] {0, 0, 0, 0, 0, 0, 0, 0, 0, 0});
    setEffectDelay(new boolean[] {true, true, true, true, true, true, true, true, true, true});
    setEffectAmplitude(new boolean[] {false, false, false, false, false, false, false, false, false, false});
    setIsActive(new boolean[] {true, true, true, true, true, true, false, false, false, false});
    setLeftAmplitudeFactor(new float[] {1, 1, 1, 1, 1, 1, 1, 1, 1, 1});
    setRightAmplitudeFactor(new float[] {1, 1, 1, 1, 1, 1, 1, 1, 1, 1});
    super._xPosition = 1;
  }
}

public class PresetSquareWave extends PresetStandard
{
  public PresetSquareWave()
  {
    setDropdownLabel("Additive Synthesis: Square Wave");
    setSummary("By combining multiple sine waves it is theoretically possible to create any repetative waveform.\n\n" +
      "A square wave is created from a sine wave with all it's odd numbered overtones.  This preset demonstrates an " + 
      "approximation of a square wave generated in this way.  The more overtones that are added, the more " +
      "defined the wave becomes.\n\nYou can explore this by settings disabling or reducinng the intensity of various wave components");
    setOvertone(new float[] {1, 3, 5, 7, 9, 11, 13, 15, 17, 19});
    setAmplitude(new float[] {1, 0.3, 0.15, 0.075, 0.0375, 0.01875, 0.009375, 0.0046875234375, 0.001171875, 0.0005859375});
    setDelay(new float[] {0, 0, 0, 0, 0, 0, 0, 0, 0, 0});
    setEffectDelay(new boolean[] {false, false, false, false, false, false, false, false, false, false});
    setEffectAmplitude(new boolean[] {false, false, false, false, false, false, false, false, false, false});
    setIsActive(new boolean[] {true, true, true, true, true, true, true, true, true, true});
    setLeftAmplitudeFactor(new float[] {1, 1, 1, 1, 1, 1, 1, 1, 1, 1});
    setRightAmplitudeFactor(new float[] {1, 1, 1, 1, 1, 1, 1, 1, 1, 1});
    super._xPosition = 1;
  }
}

public class PresetStandardAmplitude extends PresetStandard
{
  public PresetStandardAmplitude()
  {
    setDropdownLabel("Positioning: Interaural Intensity Difference (IID)");
    setSummary("One method we use to position a sound source is an  evaluation of the difference in " +
               "intensity of the signals received by ears. This is known as the 'interaural intensity difference. " +
               "This works as our heads effectively create an 'audio shadow' so a sound originating " + 
               "to our right hand side will be measurably louder in our right ear than our left ear.\n\nThis preset " +
               "simulates this in a basic way, by applying a linear reduction in intensity to individual the left and right " +
               "channels of the  wave components as the sound position moves");
    setOvertone(new float[] {1, 1, 1, 1, 1, 1, 1, 1, 1, 1});
    setAmplitude(new float[] {1, 0, 0, 0, 0, 0, 0, 0, 0, 0});
    setDelay(new float[] {0, 0, 0, 0, 0, 0, 0, 0, 0, 0});
    setEffectDelay(new boolean[] {false, false, false, false, false, false, false, false, false, false});
    setEffectAmplitude(new boolean[] {true, false, false, false, false, false, false, false, false, false});
    setIsActive(new boolean[] {true, false, false, false, false, false, false, false, false, false});
    setLeftAmplitudeFactor(new float[] {1, 1, 1, 1, 1, 1, 1, 1, 1, 1});
    setRightAmplitudeFactor(new float[] {1, 1, 1, 1, 1, 1, 1, 1, 1, 1});
    super._xPosition = 1;
  }
}

public class PresetStandardDelay extends PresetStandard
{
  public PresetStandardDelay()
  {
    setDropdownLabel("Positioning: Interaural Time Difference (ITD)");
    setSummary("One method we use to locate a sound source is an analysis of the difference in " +
               "phase of the signals received by our ears. This is known as the 'interaural time difference and works as " +
               "the distance between our ears means that a sound originating " + 
               "to our right hand side will arrive in our right ear shortly before than our left ear.\n\nThis preset " +
               "simulates this in a basic way, by applying a linear delay of up to 3ms to " +
               "left and right channels of the individual wave components as the sound position changes");
    setOvertone(new float[] {1, 1, 1, 1, 1, 1, 1, 1, 1, 1});
    setAmplitude(new float[] {1, 0, 0, 0, 0, 0, 0, 0, 0, 0});
    setDelay(new float[] {0, 0, 0, 0, 0, 0, 0, 0, 0, 0});
    setEffectDelay(new boolean[] {true, false, false, false, false, false, false, false, false, false});
    setEffectAmplitude(new boolean[] {false, false, false, false, false, false, false, false, false, false});
    setIsActive(new boolean[] {true, false, false, false, false, false, false, false, false, false});
    setLeftAmplitudeFactor(new float[] {1, 1, 1, 1, 1, 1, 1, 1, 1, 1});
    setRightAmplitudeFactor(new float[] {1, 1, 1, 1, 1, 1, 1, 1, 1, 1});
    super._xPosition = 1;
  }
}

public class PresetSilence extends PresetStandard
{
  public PresetSilence()
  {
    setDropdownLabel("Silence: Useful when switching between effects");
    setSummary("This preset can be used to 'reset' your hearing between different effects");
    setOvertone(new float[] {1, 1, 1, 1, 1, 1, 1, 1, 1, 1});
    setAmplitude(new float[] {0, 0, 0, 0, 0, 0, 0, 0, 0, 0});
    setDelay(new float[] {0, 0, 0, 0, 0, 0, 0, 0, 0, 0});
    setEffectDelay(new boolean[] {false, false, false, false, false, false, false, false, false, false});
    setEffectAmplitude(new boolean[] {false, false, false, false, false, false, false, false, false, false});
    setIsActive(new boolean[] {false, false, false, false, false, false, false, false, false, false});
    setLeftAmplitudeFactor(new float[] {1, 1, 1, 1, 1, 1, 1, 1, 1, 1});
    setRightAmplitudeFactor(new float[] {1, 1, 1, 1, 1, 1, 1, 1, 1, 1});
    super._xPosition = 1;
  }
}
