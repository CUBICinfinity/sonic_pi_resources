# Find rational approximations of values above 1.
# `val` is a float, the value to be approximated.
# `stop` is the largest allowed denominator.
# `match` is the minimum proximity to val required for inclusion as an approximation.
# Returns an array of size three arrays:
# `best_ratios[i][0]` is the numerator of the rational.
# `best_ratios[i][1]` is the denominator of the rational.
# `best_ratios[i][2]` is a decimal representation of the rational.
define :rationalize do |val, stop=17, match=0.1|
  n = 2.0
  d = 1.0
  
  # Initialize
  best = (n/d - val).abs
  init = true
  n2 = n
  while init do
    n2 += 1
    new = (n2/d - val).abs
    if (new > best)
      init = false
    else
      n = n2
    end
  end
  if best <= match
    best_ratios = [[n,d,n/d]]
  else
    best_ratios = []
  end
  
  # Main loop
  while d < stop do
    update = false
    n += 1
    d += 1
    ratio = n/d
    if (ratio - val).abs < best
      update = true
    elsif ratio.abs < val
      n += 1
      ratio = n/d
      if (ratio - val).abs < best
        update = true
      end
    elsif ratio > val
      n -= 1
      ratio = n/d
      if (ratio - val).abs < best
        update = true
      end
    end
    if update
      best = (ratio - val).abs
      if best <= match
        best_ratios = best_ratios.append([n,d,ratio])
      end
    end
  end
  
  best_ratios
end
