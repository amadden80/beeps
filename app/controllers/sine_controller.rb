class SineController < ApplicationController
	
	def index

		@demos = [
			  		{frequency: 110,  fs: 8000, seconds: 5, amplitude: 0.75, phase: 0},
				  	{frequency: 220,  fs: 8000, seconds: 4, amplitude: 0.75, phase: 0},
				  	{frequency: 440,  fs: 8000, seconds: 3, amplitude: 0.75, phase: 0},
				  	{frequency: 880,  fs: 8000, seconds: 2, amplitude: 0.75, phase: 0},
				  	{frequency: 1760, fs: 8000, seconds: 1, amplitude: 0.75, phase: 0}
				 ]
	end

	def sine

		# params
		frequency = ( params[:frequency]|| params[:freq] || 440.0 ).to_f
		srate = ( params[:fs] || 44100.0 ).to_f
		seconds = ( params[:seconds] || params[:sec] || 0.25 ).to_f
		amplitude = ( params[:amplitude] || params[:amp] || 0.75 ).to_f
		phase =  ( params[:phase] || 0.0).to_f
		
		# Clean data
		seconds = 1.0 if seconds > 10.0
		srate = 88200.0 if srate > 88200
		amplitude = 1.0 if amplitude > 1.0 

		# Filename
		filename = "wave_freq_#{frequency}_secs_#{seconds}_fs_#{srate}_amp_#{amplitude}_phase_#{phase}".gsub('.', '_') + '.wav'
      	path = Rails.root.to_s + "/public/waves/" + filename
      	puts '***************************'
      	puts filename
      	puts '***************************'

      	# Check if file already exists
      	unless File.exist?(path)

      		# Time Vector
      		num_samples = (srate * seconds).round
			time_vector = (0..(num_samples-1)).to_a.map do |samp| 
				(samp.to_f)/srate
			end

			# Sine Wave:
			angular_frequency = frequency * 2 * Math::PI
			wave = time_vector.map do |time_samp| 
				amplitude * Math.sin( time_samp * angular_frequency - phase)
			end

			# Wavefile Gen

	      	format = WaveFile::Format.new(:mono, :pcm_16, srate)
	      	writer = WaveFile::Writer.new(path, format)
	      	buffer = WaveFile::Buffer.new(wave, WaveFile::Format.new(:mono, :float, srate))
	      	writer.write(buffer)
	      	writer.close()

	     end

      	audio_url = "/waves/#{ filename }"

		redirect_to audio_url

	end
end