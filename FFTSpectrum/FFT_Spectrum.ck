// Example, @Soesilo Wijono
// get FFT spectrum
// first bin is DC (freq = 0Hz)
// make sure to filter out the DC (signal - mean(signal) => signal)
// also make sure to applying band-pass filter at Nyquist frequency
// Nyquist frequency == sampling rate / 2

// input signal
// change 'SinOsc g' to adc when needed
SinOsc g => FFT fft => blackhole;
// set samplingRate
second / samp => float samplingRate;
<<< "Sampling rate =", samplingRate >>>;

// FFT bin size
// change this as desired
16 => fft.size;

// spectrum, first half bins, 0..N/2-1
// the rest is useless, it's only conjugate of the first half
complex spectral[fft.size()/2];

// a sample frequency of the sinusoidal input
// remove this when using adc as input
5500 => g.freq;
    
// let fft.size samples pass
// change this to reflect the input duration
fft.size()::samp => now;
    
// take fast fourier transform
fft.upchuck();
// get the spectrum
fft.spectrum( spectral );

// display spectrum at Nth bin
<<< "Spectrum:" >>>;
for ( 0 => int i; i < fft.size()/2; i++ ) 
{
    i * samplingRate / fft.size() => float freq;
    <<< "bin:", i, "freq:", freq, "power:", spectral[i]$polar >>>;
}
