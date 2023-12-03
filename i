{
  "glossary": {
    "title": "example glossary",
    "GlossDiv": {
      "title": "S",
      "GlossList": {
        "GlossEntry": {
          "ID": "SGML",
          "SortAs": "SGML",
          "GlossTerm": "Standard Generalized Markup Language",
          "Acronym": "SGML",
          "Abbrev": "ISO 8879:1986",
          "GlossDef": {
            "para": "A meta-markup language, used to create markup languages such as DocBook.",
            "GlossSeeAlso": [
              "GML",
              "XML"
            ]
          },
          "GlossSee": "markup"
        }
      }
    }
  }
}

mutation CreateAndUpdateData($newPersonInput: 'PersonInput', $updatePersonInput: PersonInput, $postId: ID!) {
  # Create a new person
  createPerson(input: $newPersonInput) {
    id
    firstName
    lastName
    age
    posts {
      id
      title
      content
    }
  }
}
;
query GetComplexData($authorId: ID!, $categoryId: ID!, $postId: ID!) {
  # Get author information by ID
  author(id: $authorId) {
    id
    firstName
    lastName
    age
    profile {
      email
      avatarUrl
    }
    posts {
      id
      title
      content
      category {
        id
        name
      }
      comments {
        id
        text
        author {
          id
          firstName
          lastName
        }
      }
      likes
    }
  }

  # Get category information by ID
  category(id: $categoryId) {
    id
    name
    posts {
      id
      title
      content
      author {
        id
        firstName
        lastName
      }
    }
  }

  # Get specific post and its related data
  post(id: $postId) {
    id
    title
    content
    author {
      id
      firstName
      lastName
    }
    category {
      id
      name
    }
    comments {
      id
      text
      author {
        id
        firstName
        lastName
      }
    }
    likes
  }
}
;
