/*
Interface defining public members of a preset class
*/
public interface IWavePreset
{
  float getAmplitude(int index);
  float getDelay(int index);
  boolean getEffectDelay(int index);
  boolean getEffectAmplitude(int index);
  boolean getIsActive(int index);
  float getOvertone(int index);
  float getXPosition();
  String getSummary();
  String getDropdownLabel();
  float getLeftAmplitudeFactor(int index);
  float getRightAmplitudeFactor(int index);
}
