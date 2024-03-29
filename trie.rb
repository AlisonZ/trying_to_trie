# TODO: underscore or camelCase consistency in vars

class TrieNode
  attr_accessor :children, :end_of_word, :char, :valid_words, :original_path
  def initialize(char)
    @children = {}
    @end_of_word = false
    @char = char
    @original_path = []
    # this would be the valid_words in the scrabble class
    @valid_words = []
  end

  def add_word(word, current_node)
    word.downcase!
    letter = word[0]
    if current_node.children[letter]
      new_node = current_node.children[letter]
      if word.length > 1
        add_word(word[1..-1], new_node)
      end
    else
      new_node = TrieNode.new(letter)
      current_node.children[letter] = new_node
      if word.length > 1
        add_word(word[1..-1], new_node)
      else
        new_node.end_of_word = true
      end
    end
  end

  def wildcard_helper(all_children, node, current_path, word)
    while all_children.length > 0
      next_node = all_children.shift
      new_path = [current_path]
      new_path.push(next_node.char)
      if word.length === 1
        if next_node.end_of_word === true
          @valid_words.push(new_path.join(""))
        end
      else
        find_word(word[1..-1], next_node, new_path)
      end
    end
  end

  def find_word(word, current_node, current_path = [])
    word.downcase!
    letter = word[0]
    if current_node.children[letter]
      next_node = current_node.children[letter]
      current_path.push(next_node.char)
      if word.length === 1
        if next_node.end_of_word === true
          @valid_words.push(current_path.join(""))
        end
      else
        find_word(word[1..-1], next_node, current_path)
      end

    end
    if letter === "_"
      all_children = []
      # TODO: do this with map
      current_node.children.each do |v|
        all_children.push(v[1])
      end

      wildcard_helper(all_children, current_node, current_path, word)
    end
  end
end

root = TrieNode.new("")
root.add_word("cat", root)
root.add_word("cab", root)
root.add_word("cub", root)

# root.add_word("clb", root)
# root.add_word("cats", root)
# root.add_word("cabs", root)

# root.add_word("pig", root)

# root.find_word("dog", root)
# puts "these are the valid_words #{root.valid_words}"
# root.find_word("p_g", root)
# root.find_word("cat", root)
root.find_word("c__", root)

# root.find_word("clb", root)
# root.find_word("ca_", root)
# root.find_word("c__s", root)
# root.find_word("_a_s", root)


# root.find_word("_at", root)
# root.find_word("cat_", root)
# root.find_word("cats", root)

# root.find_word("cars", root)

# !!!! valid_words WILL BE OUTSIDE OF TRIE CLASS IN THE SCRABBLE CLASS, SO THIS IS FINE
# THE VALID WORDS WILL BE COMPILED AND ONCE FIND_WORD IS DONE RUNNING, THEN REPORT FINDINGS
# WILL USE THE valid_words
# TODO: valid_words contains dupes, so need to get rid of them in Scrabble report_findings
puts root.valid_words
