function gcd --description="Navigate to the root of the git repository"
  cd (git rev-parse --show-toplevel)
end
