/*
This class is responsible for drawing the user interface
*/
public class WaveUI
{ 
  CustomWave[] theWaves;
  IWavePreset[] _presets;
  int selectedWaveIndex;
  
  //Controls
  Slider s1;
  Slider s2;
  CheckBox checkbox; //Group of checkboxes for active, effect delay and effect amplitude flags
  Slider intensity; //Slider for wave intesity
  Slider leftAmp; //A slider to set a factor to reduce the left channel intensity 
  Slider rightAmp; //A slider to set a factor to reduce the right channel intensity 
  MyDropdownList WaveSelector; //A dropdown to select the current wave for manipulation/display
  MyDropdownList PresetSelector; //A dropdown to select a preset wave configuration
  ControlGroup cg; //A control container for the individual wave controls
  ControlGroup cgWaveDetails; //A control container for the preset and wave summary controls
  Textlabel[][] WaveSummary; //An array of labels to display the way summary details
  Textarea PresetSummary; //A text label to display a description of the preset
  Textlabel SelectPreset; //A label for select preset
  Toggle _isActive; //Reference to toggle control for isactive 
  Toggle _effectDelay; //Reference to toggle control for effect delay 
  Toggle _effectAmplitude; //Reference to toggle control for effect amplitude
  Textlabel WaveComponents;
  Textlabel ConfigureWave;
  Toggle _liveAudioOutput;
  Textlabel _showLiveOutput;
  Slider _BaseFrequency;
  
  //configure Main Output Wave drawing parameters
  int LeftCentre = 90;
  int WaveHeight = 50;
  int WaveSeparation = 130;
  
  public WaveUI(CustomWave[] waves, IWavePreset[] presets)
  {
    isDisplayUpdate = true;
    
    cg = controlP5.addGroup("ctrlGroup", 10, 303); //Control container for individual wave controls
    cg.hideBar();
    cg.setBarHeight(0);
    
    cgWaveDetails = controlP5.addGroup("cgWaveDetails", 10, 20); //Control container for wave details summary 
    cgWaveDetails.hideBar();
    cgWaveDetails.setBarHeight(0);
    
    //Initialise a pointer to the injected custom wave array in a local variable
    theWaves = waves;
    _presets = presets;
    
    //Create the Textlabel array
    int offsetY = 100;
    int offsetx = 10;
    WaveSummary = new Textlabel[11][9];
    for (int i = 0; i < 11; i++)
    {
      for (int j = 0; j < 9; j++)
      {
        WaveSummary[i][j] = controlP5.addTextlabel("txt" + i + j, "Wave " + i , 50 * j, 15 * i);
        WaveSummary[i][j].setGroup(cgWaveDetails);
        
        //Position
        switch(j){
          case 0: 
            WaveSummary[i][j].setPosition(0 + offsetx + ((i==0)?0:0), 15 * i + offsetY);
            break;
          case 1: 
            WaveSummary[i][j].setPosition(60 + offsetx + ((i==0)?0:11), 15 * i + offsetY);
            break;
          case 2: 
            WaveSummary[i][j].setPosition(140 + offsetx + ((i==0)?0:18), 15 * i + offsetY);
            break;
          case 3: 
            WaveSummary[i][j].setPosition(250 + offsetx + ((i==0)?0:7), 15 * i + offsetY);
            break;
          case 4: 
            WaveSummary[i][j].setPosition(315 + offsetx + ((i==0)?0:20), 15 * i + offsetY);
            break;
          case 5: 
            WaveSummary[i][j].setPosition(400 + offsetx + ((i==0)?0:10), 15 * i + offsetY);
            break;
          case 6: 
            WaveSummary[i][j].setPosition(480 + offsetx + ((i==0)?0:40), 15 * i + offsetY);
            break;
          case 7: 
            WaveSummary[i][j].setPosition(590 + offsetx + ((i==0)?0:40), 15 * i + offsetY);
            break;
          case 8: 
            WaveSummary[i][j].setPosition(710 + offsetx + ((i==0)?0:5), 15 * i + offsetY);
            break;
        }
      }
    }
    
    //Populate the table with wave values
    bindWaveDetails();
    
    //Create wave deatil table cloumn headers
    WaveSummary[0][0].setValue("Wave") ;
    WaveSummary[0][1].setValue("Effect Delay") ;
    WaveSummary[0][2].setValue("Effect Amplitude") ;
    WaveSummary[0][3].setValue("Intensity") ;
    WaveSummary[0][4].setValue("Additional Delay") ;
    WaveSummary[0][5].setValue("Overtone") ;
    WaveSummary[0][6].setValue("Left Amplitude Factor") ;
    WaveSummary[0][7].setValue("Right Amplitude Factor") ;
    //WaveSummary[0][8].setValue("TBC") ;
    WaveSummary[0][8].setValue("Enabled") ;
    
    //Create a group of checkboxes to indicate whether to effect delay or amplitude of currently selected wave
    checkbox = controlP5.addCheckBox("AdjustChecks",10,25);
    checkbox.setGroup(cg);  
    checkbox.setColorForeground(color(120));
    checkbox.setColorActive(color(255));
    checkbox.setColorLabel(color(128));
    checkbox.setItemsPerRow(1);
    checkbox.setSpacingColumn(30);
    checkbox.setSpacingRow(5);
  
    // add options to the group and create references to each
    _isActive = checkbox.addItem("Is Enabled",0);
    _effectAmplitude = checkbox.addItem("Effect Amplitude",1);
    _effectDelay = checkbox.addItem("Effect Delay",0);

    //Add a toggle for live output
    _liveAudioOutput = controlP5.addToggle("Live Output");
    _liveAudioOutput.setPosition(400,4);
    _liveAudioOutput.setWidth(15);
    _liveAudioOutput.setHeight(15);
    _liveAudioOutput.setColorActive(255);
    _liveAudioOutput.setLabelVisible(false);
    _showLiveOutput = controlP5.addTextlabel("Live Output Label", "LIVE OUTPUT", 420, 8);
    _showLiveOutput.setFont(0);
    _showLiveOutput.setWidth(100);
    
    //Add a slider for base frequency
    _BaseFrequency = controlP5.addSlider("Base Frequency", 50, 500, 1, 485, 5, 225, 12);
    _BaseFrequency.setValue(110);
    _BaseFrequency.setLabelVisible(true);
    
    // Add a slider to select the harmonic number of the wave
    s1 = controlP5.addSlider("Harmonics Series", 1, 20, 1, 10, 75, 200, 10);
    s1.setGroup(cg); 
    s1.setNumberOfTickMarks(20);
    s1.showTickMarks(false);
    s1.setLabel("Harmonic Overtone");
    
    //Add a slider to select any additional delay
    s2 = controlP5.addSlider("Additional Delay", 0, 5, 1, 10, 90, 200, 10);
    s2.setGroup(cg); 
    
    
    
    //Add sliders for intensity and amplitude factor
    intensity = controlP5.addSlider("Intensity",0,1,0,10,105,200,10);
    intensity.setGroup(cg); 
    leftAmp = controlP5.addSlider("Left Amplitude",0,1,0,10,120,200,10);
    leftAmp.setLabel("Left Amplitude Adjustment"); 
    leftAmp.setGroup(cg); 
    rightAmp = controlP5.addSlider("Right Amplitude",0,1,0,10,135,200,10);
    rightAmp.setLabel("Right Amplitude Adjustment"); 
    rightAmp.setGroup(cg); 
    
    //Add a slider to specify the intended location
    Slider sLoc = controlP5.addSlider("Position",-1,1,0,-10,170,width,10);
    sLoc.setGroup(cg);
    sLoc.setLabel("Audio Source Position (click blue bar to set)"); 
    sLoc.setSliderMode(Slider.FLEXIBLE);
    Label sLocValLabel = sLoc.valueLabel();
    sLocValLabel.setVisible(false);

    Label sLocCapLabel = sLoc.captionLabel();
    sLocCapLabel.setVisible(true);
    sLocCapLabel.style().moveMargin(-10,-0,0,-width/2 - sLocCapLabel.width() / 2);
    
    //Create a dropdown for selecting a specific wave
    //Note: This is the last control to be drawn so that it remains on top when dropped down otherwise is is drawn behind other controls
    WaveSelector = new MyDropdownList(controlP5, cg, "WavePicker", 10, 20, 100, 120);
    WaveSelector.setItemHeight(10);
    WaveSelector.setBarHeight(15);
    WaveSelector.captionLabel().set("Select Wave");
    WaveSelector.captionLabel().style().marginTop = 3;
    WaveSelector.captionLabel().style().marginLeft = 3;
    WaveSelector.valueLabel().style().marginTop = 3;
    
    //Add the wave selectors to the dropdown
    for(int i = 0; i < theWaves.length; i++) {
      WaveSelector.addItem("Wave " + (i+1),i);
    }
    
    //Create the preset summary label
    PresetSummary = controlP5.addTextarea("PresetSummary", "Preset Summary Box", 5, 8, 750, 100);
    PresetSummary.setGroup(cgWaveDetails);
    
    //Create the wave components label
    WaveComponents = controlP5.addTextlabel("WaveComponents", "Wave Components:", 0, 80);
    WaveComponents.setGroup(cgWaveDetails);
    
    //Create the configure wave  label
    ConfigureWave = controlP5.addTextlabel("ConfigureWave", "Configure Wave Component:", 0, 270);
    ConfigureWave.setGroup(cgWaveDetails);
    
    //Create the select preset
    SelectPreset = controlP5.addTextlabel("SelectPreset", "Select Preset:", 0, -12);
    SelectPreset.setGroup(cgWaveDetails);
    
    //Create a preset dropdown
    PresetSelector = new MyDropdownList(controlP5, cgWaveDetails, "PresetPicker", 75, 0, 300, 350);
    PresetSelector.setItemHeight(25);
    PresetSelector.setBarHeight(15);
    PresetSelector.captionLabel().set("Select Preset");
    PresetSelector.captionLabel().style().marginTop = 3;
    PresetSelector.captionLabel().style().marginLeft = 3;
    PresetSelector.valueLabel().style().marginTop = 3;
   
    //Add presets to the dropdown
    for(int i = 0; i < _presets.length; i++) {
      PresetSelector.addItem(_presets[i].getDropdownLabel(),i);
    }
    
    isDisplayUpdate = false;
  }
  
  //Select which wave to load into the UI
  public void SelectWave(int index)
  {
    selectedWaveIndex = index;
    if (debug)
      println("WaveUI: Wave index " + index + " selected");
      
    WaveSelector.setIndex(index);
    WaveSelector.setOpen(false);
    
    //Update the interface with the values of the selected control
    populateControls();
  }
  
  //Update the preset dropdown control
  public void SelectPreset(int index)
  {
    //Update preset dropdown display
    PresetSelector.setIndex(index);
    PresetSelector.setOpen(false);
    
    //Iterate through waves and apply preset values
    for (int i = 0; i < theWaves.length; i++)
    { 
      //println("WaveUI.SelectPreset: Setting wave " + i);
      //println("IsActive: " + _presets[index].getIsActive(i));
    
      theWaves[i].setMaxAmp(_presets[index].getAmplitude(i));
      theWaves[i].setAddDelay(_presets[index].getDelay(i));
      theWaves[i].setEffectDelay(_presets[index].getEffectDelay(i));
      theWaves[i].setEffectAmplitude(_presets[index].getEffectAmplitude(i));
      theWaves[i].setIsActive(_presets[index].getIsActive(i));
      theWaves[i].setHarmonicIndex(_presets[index].getOvertone(i));
      theWaves[i].setLeftAmpMultiplier(_presets[index].getLeftAmplitudeFactor(i));
      theWaves[i].setRightAmpMultiplier(_presets[index].getRightAmplitudeFactor(i));
      theWaves[i].setOffset(0);
    }
    
    //Update the preset description
    PresetSummary.setText(_presets[index].getSummary());
    
    //Update the wave summary table
    bindWaveDetails();
    
    //Update the selected wave displayed values
    populateControls();
  }
  
  //Populate the UI with the parameters from the selected wave
  private void populateControls()
  {
    //println("WaveUI.PopulateControls: SelectedWaveIndex = " + selectedWaveIndex);
    
    //Create pointer to selected wave for convenience
    CustomWave cw = theWaves[selectedWaveIndex];
    
    //println("WaveUI.PopulateControls: cw.IsActive = " + cw.getIsActive());
    //println("WaveUI.PopulateControls: cw.EffectAmplitude = " + cw.getEffectAmplitude());
    //println("WaveUI.PopulateControls: cw.EffectDelay = " + cw.getEffectDelay());
    
    //Update static flag indicating UI Update - Required as workaround for ControlP5 library missing
    //a setBroadcast flag that an be assigned to a checkbox group
    isDisplayUpdate = true;
    
    //Update slider for harmonic value
    s1.setValue(cw.getHarmonicIndex());
    
    if (cw.getIsActive())
      checkbox.activate(0);
    else
      checkbox.deactivate(0);
    
    //Update effect delay checkbox
    if (cw.getEffectDelay())
      checkbox.activate(2);
    else
      checkbox.deactivate(2);
      
    //Update effect amplitude checkbox
    if (cw.getEffectAmplitude())
      checkbox.activate(1);
    else
      checkbox.deactivate(1);

    //Update the amplitiude factor sliders
    intensity.setValue(cw.getMaxAmp());
    leftAmp.setValue(cw.getLeftAmpMultiplier());
    rightAmp.setValue(cw.getRightAmpMultiplier());
    
    //Set additional delay slider value
    s2.setValue(cw.getAddDelay());
    
    //End UI updatte
    isDisplayUpdate = false;
  }
  
  public void bindWaveDetails()
  {
    for (int k = 1; k <= 10; k++)
    {
      populateWaveDetails(k);
    }
  }
  
  //Populate the wave details table from the current wave array
  public void populateWaveDetails(int i)
  {
    //Configure 2 decimal point output for float values
    DecimalFormat df2 = new DecimalFormat( "#########0.00" );
    
    for (int j = 0; j < theWaves.length; j++)
    {
      //Set the values
      switch(j){
        case 1: 
          WaveSummary[i][j].setValue(theWaves[i-1].getEffectDelay()?"True":"False");
          break;
        case 2: 
          WaveSummary[i][j].setValue(theWaves[i-1].getEffectAmplitude()?"True":"False");
          break;
        case 3: 
          WaveSummary[i][j].setValue(String.valueOf(df2.format(theWaves[i-1].getMaxAmp())));
          break;
        case 4: 
          WaveSummary[i][j].setValue(String.valueOf(df2.format(theWaves[i-1].getAddDelay())));
          break;
        case 5: 
          WaveSummary[i][j].setValue(String.valueOf(theWaves[i-1].getHarmonicIndex()));
          break;
        case 6: 
          WaveSummary[i][j].setValue(String.valueOf(df2.format(theWaves[i-1].getLeftAmpMultiplier())));
          break;
        case 7: 
          WaveSummary[i][j].setValue(String.valueOf(df2.format(theWaves[i-1].getRightAmpMultiplier())));
          break;
        case 8: 
          WaveSummary[i][j].setValue(theWaves[i-1].getIsActive()?"True":"False");
          break;
        //case 9: 
        //  WaveSummary[i][j].setValue(theWaves[i-1].getIsActive()?"True":"False");
        //  break;
      }
    }
  }
  
  //Draw the main output waveform
  public void drawWaveform()
  {
    drawBackgroundElements();
    
    //draw the output wave
    pushMatrix();
    translate(0,450);
    
    //Iterate through each wave and add to buffer
    for(int i = 0; i < _combinedWaveLeft.length; i++)
    {
      _combinedWaveLeft[i] = 0;
      _combinedWaveRight[i] = 0;
      for (int j = 0; j < signals.length; j++)
      {
        _combinedWaveLeft[i] += signals[j].getLeftSignal()[i];
        _combinedWaveRight[i] += signals[j].getRightSignal()[i];
      }
    }
    
    //Draw the grid for displaying the waveforms
    fill(0,25,0);
    rect(0, LeftCentre - WaveHeight, width, 2 * WaveHeight);
    rect(0, LeftCentre + WaveSeparation - WaveHeight, width, 2 * WaveHeight);
    
    stroke(0,50,0);
    line(0, LeftCentre, width, LeftCentre);
    line(0, LeftCentre + WaveSeparation, width, LeftCentre + WaveSeparation);
    line(0, LeftCentre - WaveHeight, width, LeftCentre - WaveHeight);
    line(0, LeftCentre + WaveHeight, width, LeftCentre + WaveHeight);
    line(0, LeftCentre + WaveSeparation, width, LeftCentre + WaveSeparation);
    line(0, LeftCentre + WaveSeparation - WaveHeight, width, LeftCentre + WaveSeparation - WaveHeight);
    line(0, LeftCentre + WaveSeparation + WaveHeight, width, LeftCentre + WaveSeparation + WaveHeight);
    
    if (!_drawLiveWave) 
    {
      //Use combined wave calculation to draw wave
      for(int i = 0; i < _bufferSize - 1; i++)
      {
        //Draw wave
        float x1 = map(i, 0, _combinedWaveLeft.length, 0, width);
        float x2 = map(i+1, 0, _combinedWaveRight.length, 0, width);
        
        //Colour red if exceeding clipping value otherwise colour green
        if (abs(_combinedWaveLeft[i]) > 1 || abs(_combinedWaveLeft[i + 1]) > 1)
          stroke(255,0,0);
        else 
          stroke(0,255,0);
        
        //Draw left channel  
        line(x1, LeftCentre + _combinedWaveLeft[i] * WaveHeight, x2, LeftCentre + _combinedWaveLeft[i+1] * WaveHeight);
        
        //Colour red if exceeding clipping value otherwise colour green
        if (abs(_combinedWaveRight[i]) > 1 || abs(_combinedWaveRight[i + 1]) > 1)
          stroke(255,0,0);
        else 
          stroke(0,255,0);
        
        //Draw right channel
        line(x1, LeftCentre + WaveSeparation + _combinedWaveRight[i] * WaveHeight, x2, LeftCentre + WaveSeparation + _combinedWaveRight[i+1] * WaveHeight);
      }
    } 
    else
    {
      //Use output buffer to draw wave - results in moving wave due to phase offset on each buffer refresh
      for(int i = 0; i < out.bufferSize() - 1; i++)
      {      
        
          float x1 = map(i, 0, out.bufferSize(), 0, width);
          float x2 = map(i+1, 0, out.bufferSize(), 0, width);
          
          //Colour red if exceeding clipping value otherwise colour green
          if (abs(out.left.get(i)) > 1 || abs(out.left.get(i+1)) > 1)
            stroke(255,0,0);
          else 
            stroke(0,255,0);
            
          //Draw left channel
          line(x1, LeftCentre + out.left.get(i) * WaveHeight, x2, LeftCentre + out.left.get(i+1) * WaveHeight);
          
          //Colour red if exceeding clipping value otherwise colour green
          if (abs(out.right.get(i)) > 1 || abs(out.right.get(i+1)) > 1)
            stroke(255,0,0);
          else 
            stroke(0,255,0);
            
          //Draw right channel
          line(x1, LeftCentre + WaveSeparation + out.right.get(i) * WaveHeight, x2, LeftCentre + WaveSeparation + out.right.get(i+1) * WaveHeight);
      }
    }
    
    //Draw a vertical line to indicate the current audio source position x location
    stroke(255,255,0);
    line(map(signals[1].getXLocation(),-1,1,0,width), LeftCentre - WaveHeight, map(signals[1].getXLocation(),-1,1,0,width), LeftCentre + WaveSeparation + WaveHeight);
    popMatrix();
    
    drawWave();
  }
  
  public void drawBackgroundElements()
  {
    
    
    //Background of preset summary
    stroke(0,105,140);
    fill(0,4,32);
    rect(10,22,775,70);
    
    //Background for wave details table
    stroke(0,105,140);
    fill(0,4,32);
    rect(10,112,775,170);
    line(10,131,785,131);
    
    stroke(0,35,70);
    line(10,145,785,145);
    line(10,160,785,160);
    line(10,175,785,175);
    line(10,190,785,190);
    line(10,205,785,205);
    line(10,220,785,220);
    line(10,235,785,235);
    line(10,250,785,250);
    line(10,265,785,265);
    
    //Background for wave component
    stroke(0,105,140);
    fill(0,4,32);
    rect(10,300,775,155);
    
    //Panel for individual waveform 
    stroke(0,105,140);
    fill(0,0,0);
    rect(360, 320, 400, 120);
    stroke(0,50,0);
    
    //Background for individual waveforms
    fill(0,20,0);
    rect(361, 330, 398, 40);
    line(360, 330, 760, 330);
    line(360, 350, 760, 350);
    line(360, 370, 760, 370);
    
    rect(361, 390, 398, 40);
    line(360, 390, 760, 390);
    line(360, 410, 760, 410);
    line(360, 430, 760, 430);
  }
  
  
  //Draw the waveform for the currently selected wave
  public void drawWave()
  {
    //Create pointer to selected wave for convenience
    CustomWave cw = theWaves[selectedWaveIndex];
    
    //Draw in green
    stroke(0,255,0);
    
    // draw the first 500 points of the waveform
    for(int i = 0; i < 400; i+=1)
    {
      float x1 = 360; //X location
      float y1 = 350; //Y Location
      float separation = 60; //Distance between eft and right waves
      point(x1 + i, y1 + (float)(cw.getLeftSignal()[i] * 20));
      point(x1 + i, y1 + separation + (float)(cw.getRightSignal()[i] * 20));
    }
  }
}
