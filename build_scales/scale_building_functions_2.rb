# Same as scale_building_functions.rb, but `tile` function is merged with `edx` and `ji`

# Equal Temperament
define :edx do
  | mode = [2,2,1,2,2,2],
    tet = 12,
    equave = 2,
    root = 60,
    tile = false |
  notes = [midi_to_hz(root)]
  for i in 0..(mode.length-1) do
    notes = notes.append(notes[i] * equave ** (1.0*mode[i] / tet))
  end
  
  if tile != false
    initial_notes = notes
    current_notes = initial_notes
    done = false
    
    while done != true do
      current_notes = current_notes.map { |n| n/tile }
      notes = current_notes + notes
      if notes[0] < midi_to_hz(0)
        s = 0
        while notes[s] < midi_to_hz(0) do
          s += 1
        end
        notes = notes.drop(s+1)
        done = true
      end
    end
    
    current_notes = initial_notes
    done = false
    
    while done != true do
      current_notes = current_notes.map { |n| n*tile }
      notes = notes + current_notes
      if notes[notes.length-1] >= midi_to_hz(128)
        s = notes.length - 1
        while notes[s] >= midi_to_hz(128) do
          s -= 1
        end
        notes = notes.take(s+1)
        done = true
      end
    end
  end
  
  notes.ring.map { |n| hz_to_midi(n) }
end

# Just Intonation
define :ji do
  | values = [9/8.0, 5/4.0, 4/3.0, 3/2.0, 5/3.0, 15/8.0],
    root = 60,
    tile = false |
  notes = [midi_to_hz(root)]
  for i in 0..(values.length - 1) do
    notes = notes.append(notes[0] * values[i])
  end
  
  if tile != false
    initial_notes = notes
    current_notes = initial_notes
    done = false
    
    while done != true do
      current_notes = current_notes.map { |n| n/tile }
      notes = current_notes + notes
      if notes[0] < midi_to_hz(0)
        s = 0
        while notes[s] < midi_to_hz(0) do
          s += 1
        end
        notes = notes.drop(s+1)
        done = true
      end
    end
    
    current_notes = initial_notes
    done = false
    
    while done != true do
      current_notes = current_notes.map { |n| n*tile }
      notes = notes + current_notes
      if notes[notes.length-1] >= midi_to_hz(128)
        s = notes.length - 1
        while notes[s] >= midi_to_hz(128) do
          s -= 1
        end
        notes = notes.take(s+1)
        done = true
      end
    end
  end
  
  notes.ring.map { |n| hz_to_midi(n) }
end


# Convert midi to sample `pitch:` values
define :midi_pitch do |notes, center=nil|
  if center.nil?
    center = notes[0] + (notes[notes.length - 1] - notes[0]) / 2
  end
  
  notes.map { |n| n - center }
end
