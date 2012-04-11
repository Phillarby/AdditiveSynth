/*
  This application was created as a coursework submission for a Creative Computing degree course, run by the University of London's distance learning program.
  Further information on this and other courses are available through their website at http://www.londoninternational.ac.uk
  
  This application uses the Minim and ControlP5 libraries to create an additive synth that can be configured to explore some of the principles of audio perception
*/

import controlP5.*;
import ddf.minim.*;
import ddf.minim.signals.*;
import java.lang.Math;

float x = 0;
ControlP5 controlP5; //Declare the control library
CustomWave[] signals; //Decalre an array of wave signals.  
int ptr; // A pointer to the index of the currently selected wave
boolean debug = false; //Flag to determine if addition debug information is printed to the output panel.
WaveUI w; //Declare user interface
float[] _combinedWaveLeft; //Use as a holder the the combined left channel signal to remove movement due to buffer flush
float[] _combinedWaveRight; //Use as a holder the the combined left channel signal to remove movement due to buffer flush
boolean _drawLiveWave = false; //Select whether to draw the live output stream including phase shifting or a standing wave without phase shifting
IWavePreset[] _presets; //An array of preset configurations
boolean isDisplayUpdate = false; //Workaround for missing setBroadcast on P5ControlGroup preventing UI updates to checkboxes without triggering events

//Set the initial base frequency
float _baseFrequency = 110; //110 Hz corresponds to A2

//Keep buffer size a factor of the sample rate to avoid 
//signal clipping - Not entirely sure why this happens, but it does
int _bufferSize = 1024;
int _sampRate = 44100;

Minim minim;
AudioOutput out;

//Run once at application launch
void setup()
{
  //Set window size
  size(800,730);
  
  //Instantiate user control library
  controlP5 = new ControlP5(this);

  //Instantiate user control library
  minim = new Minim(this);
  out = minim.getLineOut(Minim.STEREO, _bufferSize, _sampRate);
  
  //Instantiate an array of 10 individual audio waves
  signals = new CustomWave[10];
  _combinedWaveLeft = new float[round(_bufferSize)];
  _combinedWaveRight = new float[round(_bufferSize)];
  
  //Initialise each wave and add it to the output stream
  for (int i = 1; i <= signals.length; i++)
  {
    signals[i-1] = new CustomWave(0, _baseFrequency, 0);
    out.addSignal(signals[i-1]);
  }
  
  //Build preset list
  _presets = new IWavePreset[12];
  _presets[0] = new PresetStandard();
  _presets[1] = new PresetStandardAmplitude();
  _presets[2] = new PresetStandardDelay();
  _presets[3] = new PresetPositionBoth();
  _presets[4] = new PresetOvertones();
  _presets[5] = new PresetPolyrhythm();
  _presets[6] = new PresetPolyrhythmEqual();
  _presets[7] = new PresetSawWave();
  _presets[8] = new PresetSquareWave();
  _presets[9] = new PresetInharmonic();
  _presets[10] = new PresetRhythm();
  _presets[11] = new PresetSilence();
  
  //Initialise the UI components injecting the wave array and presets list
  w = new WaveUI(signals, _presets);
  
  //Select the first waveform
  SelectWave(0);
  
  //Select the first preset
  w.SelectPreset(0);
  
  //Set default x position of audio source
  x=0;
}

//Run on each draw cycle
void draw()
{

  //Clear the screen in advance of each draw cycle
  background(0);
  stroke(0,255,0);
  
  //Update parameters of each wave
  for (int i = 0; i < signals.length; i++)
  {
    //signals[i].setMaxAmp(amps[i]);
    //signals[i].setMaxDel(del[i]);
    signals[i].setXPosition(x);
  }
  
  //Draw the UI
  w.drawWaveform();
}
  
//handle events from the ControlP5 library controls
void controlEvent(ControlEvent theEvent) 
{ 
  if(debug)
  {
    if (theEvent.isGroup()) 
      println("Group Event: " + theEvent.group().name() + ": " + (int)theEvent.group().value());
    else
      println("Controller Event: " + theEvent.controller().name() + ": " + theEvent.controller().value());
  }
  
  if (theEvent.isGroup() && !isDisplayUpdate) 
  {
    //Set up for wave picker
    if (theEvent.group().name() == "WavePicker")
    {
      //println(theEvent.group().value());
      //ptr = (int)theEvent.group().value();
      SelectWave((int)theEvent.group().value());
    }
    
    //Set up for wave picker
    if (theEvent.group().name() == "PresetPicker")
    {
      //println(theEvent.group().value());
      //ptr = (int)theEvent.group().value();
      w.SelectPreset((int)theEvent.group().value());
    }
    
    //Set up checkbox events
    if (theEvent.group().name() == "AdjustChecks")
    {
      //println("Is Active: " + (theEvent.group().arrayValue()[0] != 0 ));
      //println("Effect Amplitude: " + (theEvent.group().arrayValue()[1] != 0));
      //println("Effect Delay: " + (theEvent.group().arrayValue()[2] != 0 ));

      signals[ptr].setIsActive((theEvent.group().arrayValue()[0] != 0 ));
      signals[ptr].setEffectAmplitude((theEvent.group().arrayValue()[1] != 0 ));
      signals[ptr].setEffectDelay((theEvent.group().arrayValue()[2] != 0 ));
    }
    
    w.populateWaveDetails(ptr + 1);
  }
  else if(theEvent.isController() && !isDisplayUpdate) 
  {
    //Set up for sound location changes
    if (theEvent.controller().name() == "Position")
    {
      x = theEvent.controller().value();
      //println("Position x: " + x);
    }

    //Set up for hermonic series changes
    if (theEvent.controller().name() == "Harmonics Series")
      signals[ptr].setHarmonicIndex(theEvent.controller().value());

    //Set up for amplitude changes
    if (theEvent.controller().name() == "Intensity")
      signals[ptr].setMaxAmp(theEvent.controller().value());
    if (theEvent.controller().name() == "Left Amplitude")
      signals[ptr].setLeftAmpMultiplier(theEvent.controller().value());
    if (theEvent.controller().name() == "Right Amplitude")
      signals[ptr].setRightAmpMultiplier(theEvent.controller().value());
      
    //Set up for delay changes
    if (theEvent.controller().name() == "Additional Delay")
      signals[ptr].setAddDelay(theEvent.controller().value());
      
    //Set up for wave display toggle
    if (theEvent.controller().name() == "Live Output")
    {
      //println("Live Output Adjusted");
      _drawLiveWave = (theEvent.controller().value()==1)?true:false;
    }
      
    //Set up for base frequency changes
    if (theEvent.controller().name() == "Base Frequency")
    {
      _baseFrequency  = (theEvent.controller().value()); 
      
      for(int i = 0; i < signals.length; i++)
      {
        signals[i].setFrequency(_baseFrequency * signals[i].getHarmonicIndex());
      }
    }
     
    //Refresh the UI with any updated values for the selected wave.
    w.populateWaveDetails(ptr + 1);
  }
}

//Select a wave to manipulate
private void SelectWave(int index)
{
  ptr = index;
  w.SelectWave(index);
}

public void WaveDetailsTable()
{
  //Declare controls
  Textlabel[] WaveNumbers;
  
    WaveNumbers = new Textlabel[10];
    
    for (int i = 0; i < WaveNumbers.length; i++)
    {
      WaveNumbers[i] = new Textlabel(this, "wave: " + i, 100, 0 + 25 * i);
    }

}
