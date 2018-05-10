# TODO: underscore or camelCase consistency in vars

class TrieNode
  attr_accessor :children, :endOfWord, :char, :valid_words
  def initialize(char)
    @children = {}
    @endOfWord = false
    @char = char
    # this would be the valid_words in the scrabble class
    @valid_words = []
  end

  def add_word(word, current_node)
    word.downcase!
    letter = word[0]
    if current_node.children[letter]
      newNode = current_node.children[letter]
      if word.length > 1
        add_word(word[1..-1], newNode)
      end
    else
      newNode = TrieNode.new(letter)
      current_node.children[letter] = newNode
      if word.length > 1
        add_word(word[1..-1], newNode)
      else
        newNode.endOfWord = true
      end
    end
  end

  def wildcard_helper(all_children, word, current_path)
    length = current_path.length - 1
    if word.length === 1
      all_children.each do |nextNode|
        if nextNode.endOfWord === true
          current_path.push(nextNode.char)
          @valid_words.push(current_path.join(""))
          current_path = current_path[0..length]
        end
      end
    else
      all_children.each do |nextNode|
        newWord = word[1..-1]
        find_word(newWord, nextNode, current_path)
        current_path = current_path[0..length]
      end
    end
  end

  def find_word(word, current_node, current_path = [])
    word.downcase!
    letter = word[0]
    if letter === "_"
      if current_node.children.length > 1
        current_path.push(current_node.char)
        all_children = []
        current_node.children.each do |v|
          all_children.push(v[1])
        end
        wildcard_helper(all_children, word, current_path)
      else
        onlyChild = current_node.children.first[1]
        if onlyChild.endOfWord === true && word.length === 1
          current_path.push(current_node.char)
          current_path.push(onlyChild.char)
          @valid_words.push(current_path.join(""))
        elsif word.length > 1
          current_path.push(current_node.char)
          nextNode = onlyChild
          word = word[1..-1]
          find_word(word, nextNode, current_path)
        end

      end

    elsif current_node.children[letter]
      current_path.push(current_node.char)
      nextNode = current_node.children[letter]
      if word.length > 1
        find_word(word[1..-1], nextNode, current_path)
      elsif nextNode.endOfWord === true
        current_path.push(nextNode.char)
        @valid_words.push(current_path.join(""))
      end
    end
  end
end

root = TrieNode.new("")
root.add_word("cat", root)
root.add_word("cab", root)
# root.add_word("cut", root)

# root.add_word("clb", root)
root.add_word("cats", root)
root.add_word("cabs", root)

# root.add_word("pig", root)

# root.find_word("dog", root)
# puts "these are the valid_words #{root.valid_words}"
# root.find_word("p_g", root)
# root.find_word("cat", root)
# root.find_word("c_t", root)

# root.find_word("clb", root)
root.find_word("ca_", root)
root.find_word("c__s", root)
root.find_word("_a_s", root)


# root.find_word("_at", root)
# root.find_word("cat_", root)
# root.find_word("cats", root)

# root.find_word("cars", root)

# !!!! valid_words WILL BE OUTSIDE OF TRIE CLASS IN THE SCRABBLE CLASS, SO THIS IS FINE
# THE VALID WORDS WILL BE COMPILED AND ONCE FIND_WORD IS DONE RUNNING, THEN REPORT FINDINGS
# WILL USE THE valid_words
# TODO: valid_words contains dupes, so need to get rid of them in Scrabble report_findings
puts root.valid_words
