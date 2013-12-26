// Example, @Soesilo Wijono
// get FFT spectrum
// calculate main frequency (approx)
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
1024 => fft.size;

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

// calculate highest power peak, 
// which is the main frequency
0 => float highestPower;
-1 => int highestIndex;
for ( 0 => int i; i < fft.size()/2; i++ ) 
{
    if ((spectral[i]$polar).mag > highestPower) 
    {
        (spectral[i]$polar).mag => highestPower;
        i => highestIndex;
    }
}
// calculate main freq approximation
highestIndex * samplingRate / fft.size() => float freq0;
<<< "Main frequency (approx):" >>>;
<<< "bin:", highestIndex, "freq:", freq0 >>>;
<<< "magnitude:", (spectral[highestIndex]$polar).mag, 
    "phase:", (spectral[highestIndex]$polar).phase >>>;
