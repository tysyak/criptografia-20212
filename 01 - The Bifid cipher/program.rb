#!/usr/bin/env ruby

##
# Esta calse se encarga de encriptar y desencriptar usando
# el cifrado Bifid
class BifidCipher
  attr_accessor :frase, :tabla, :indices

  ##
  # Crea una instancia de esta clase, opcionalmente se puede otorgar una
  # tableau
  def initialize(
        frase="",
        tabla=[
          ['E', 'N', 'C', 'R', 'Y'],
          ['P', 'T', 'A', 'B', 'D'],
          ['F', 'G', 'H', 'I', 'K'],
          ['L', 'M', 'O', 'Q', 'S'],
          ['U', 'V', 'W', 'X', 'Z']
        ],
        indices=[]
      )
    @frase = frase.gsub(/\s+/, "")
    @tabla = tabla
    @indices = indices
  end

  ##
  # Desencripta una frase dada
  # @param body [String] es la frase a desencriptar
  # @return [String] La frase desencriptada
  def decrypt(body=@frase)
    @frase = body.gsub(/\s+/, "")
    ret = ""
    get_index
    mid1 = @indices.flatten.each_slice(@indices.flatten.size/2).to_a[0]
    mid2 = @indices.flatten.each_slice(@indices.flatten.size/2).to_a[1]

    dec = mid1.zip(mid2)
    dec.each { |x, y| ret << @tabla[x][y] }
    return ret
  end

  ##
  # Encripta una frase
  # @param body [String] La frase a Encriptar
  # @return [String] La frase encriptada
  def encrypt(body=@frase)
    @frase = body.gsub(/\s+/, "")
    ret = ""
    get_index
    enc = Array.new
    for x in @indices;enc << x[0];end
    for x in @indices;enc << x[1]; end
    enc = enc.each_slice(2).to_a
    enc.each{|x,y| ret << @tabla[x][y]}
    return ret
  end

  private

  def get_index
    @frase.each_char do
      |char|
      renglon = 0
      @tabla.each do
        |row|
        if row.include?(char)
          @indices.push([renglon, row.index(char)])
        end
        renglon += 1
      end
    end
  end
end

# MAIN
lines = $stdin.readlines
method = lines[0].gsub(/\s+/, "")
body = lines[1].gsub(/\s+/, "")

cipher = BifidCipher.new

# puts cipher.encrypt("BRING ALL YOUR MONEY")
# puts cipher.decrypt("PDRRNGBENOPNIAGGF")

case method
when "DECRYPT"
  puts cipher.decrypt(body)
when "ENCRYPT"
  puts cipher.encrypt(body)
else
  :nop
end
