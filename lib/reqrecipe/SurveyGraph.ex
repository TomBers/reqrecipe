defmodule SurveyGraph do

  @nn_id "NEW_NODE"

  def draw_graph(g) do
    name = "newgraph"
    {:ok, file} = File.open("#{name}.dot", [:write])
    IO.binwrite(file, g)
    File.close(file)
    System.cmd("sh", ["-c", "cd  /Users/tomberman/Development/reqrecipe/; dot -Tpng #{name}.dot > #{name}.png"])
    System.cmd("open", ["#{name}.png"])
  end

  def run do
    get_graph() |> draw_graph
  end

  def branches() do
    logic()
    |> Enum.flat_map(fn(l) -> calc_branches(l) end)
  end

  def calc_branches(l) do
    ref = get_title_from_ref(l["ref"])
    l["actions"]
    |> Enum.map(fn(action) -> make_link(ref, get_title_from_ref(action["details"]["to"]["value"])) end)
  end

  def get_title_from_ref(ref) do
    fields = branch_json()["fields"]
    field = Enum.find(fields, fn(f) -> f["ref"] == ref end)
    field["id"]
  end

  def logic() do
    branch_json()["logic"]
  end

  def build_fields() do
    fields = branch_json()["fields"]

    fields
    |> Enum.map(fn(field) -> field["id"] end)
  end

  def make_link(a, b) do
    %{from: a, to: b}
  end

  def link_to_string(link) do
    "\"#{link.from}\" -> \"#{link.to}\""
  end


  def get_links do
    f = build_fields()
    scan_l  = length(f) - 1
    Enum.map(0..scan_l, fn x -> make_link(Enum.at(f, x), Enum.at(f, x + 1)) end)
  end

  def get_graph() do
    t = 'strict digraph {'
    e = '}'

    nodes = build_fields()
    links = Enum.concat(get_links(), branches()) |> Enum.uniq

    {nodes, links} = add_new_node_before("S6qkTwC18V4f", nodes, links)

#    {nodes, links} = add_new_node_before("PQUY2GGzHhLa", nodes, links)

#    {nodes, links} = remove_node("pzWcYIv4Fzhk", nodes, links)
#    {nodes, links} = remove_node("S6qkTwC18V4f", nodes, links)
#    {nodes, links} = remove_node("PQUY2GGzHhLa", nodes, links)

    node_txt = nodes |> node_string
    link_txt = links |> link_string
    "#{t} #{node_txt} #{link_txt} \n #{e}"
  end


  def remove_node(id, nodes, links) do
    nns = List.delete(nodes, id)
    parents = Enum.filter(links, fn(x) -> x.to == id end)
    children = Enum.filter(links, fn(x) -> x.from == id end)

    links = Enum.reduce(parents,links, fn(node, acc) -> remove_link(node, acc, children) end) |> Enum.filter(fn(%{from: from, to: to}) -> from != id and to != id end)
    {nns, links}
  end

  def remove_link(node, links, children) do
    lid = Enum.find_index(links, fn(x) -> x == node end)
    nls = Enum.map(children, fn(child) -> %{from: node.from, to: child.to} end)
    links = List.replace_at(links, lid, nls) |> List.flatten
  end

#  def remove_node(id, nodes, links) do
#    nns = List.delete(nodes, id)
#
#    parent = Enum.find(links, fn(x) -> x.to == id end)
#    child = Enum.find(links, fn(x) -> x.from == id end)
#
#    lid = Enum.find_index(links, fn(x) -> x.to == id end)
#
#    nl = %{from: parent.from, to: child.to}
#    links = List.replace_at(links, lid, nl) |> List.delete(parent) |> List.delete(child)
#
#
#    {nns, links}
#  end

  def add_new_node_before(id, nodes, links) do
    indx = Enum.find_index(nodes, fn(x) -> x == id end)
    nns = List.insert_at(nodes, indx, @nn_id)

    links = add_to_links(id, links)
#    IO.inspect(get_no_parents("B9vOSIbvqEsh", links))
#    IO.inspect(get_no_children("B9vOSIbvqEsh", links))
    {nns, links}
  end

  def add_to_links(id, links) do
    parents = Enum.filter(links, fn(x) -> x.to == id end)
    Enum.reduce(parents,links, fn(node, acc) -> insert_link(node, acc) end)
  end

  def insert_link(link, links) do
    lid = Enum.find_index(links, fn(x) -> x == link end)
    nl = [%{from: link.from, to: @nn_id}, %{from: @nn_id, to: link.to}]
    links = List.replace_at(links, lid, nl) |> List.flatten
  end



  def get_no_parents(id, g) do
    parents = Enum.filter(g, fn(x) -> x.to == id end)
    length(parents)
  end

  def get_no_children(id, g) do
    children = Enum.filter(g, fn(x) -> x.from == id end)
    length(children)
  end

  def node_string(nodes) do
   nodes |> Enum.reduce("", fn x, acc -> "#{acc} \n \"#{x}\"" end)
  end

  def link_string(links) do
    links |> Enum.reduce("", fn x, acc -> "#{acc} \n #{link_to_string(x)}" end)
  end

#  def get_graph() do
#    'strict digraph {
#	"a"
#	"b"
#	"c"
#	"d"
#	"a" -> "b" [weight=1]
#	"b" -> "d" [weight=1]
#	"c" -> "b" [weight=1]
#}'
#  end


  def branch_json() do
    Jason.decode!('
      {
    "id": "jo8KJj",
    "title": "Branching Test",
    "theme": {
        "href": "https://api.typeform.com/themes/6lPNE6"
    },
    "workspace": {
        "href": "https://api.typeform.com/workspaces/iY5G9Y"
    },
    "settings": {
        "is_public": true,
        "is_trial": false,
        "language": "en",
        "progress_bar": "percentage",
        "show_progress_bar": true,
        "show_typeform_branding": true,
        "meta": {
            "allow_indexing": false
        }
    },
    "thankyou_screens": [
        {
            "ref": "default_tys",
            "title": "Done! Your information was sent perfectly.",
            "properties": {
                "show_button": false,
                "share_icons": false
            }
        }
    ],
    "fields": [
        {
            "id": "mk1RXcduAWKd",
            "title": "Short question test4",
            "ref": "8d6248ab-77cc-4d6a-8387-02c05eb6b46c",
            "validations": {
                "required": false
            },
            "type": "short_text"
        },
        {
            "id": "B9vOSIbvqEsh",
            "title": "When?",
            "ref": "1c44d061-eda2-4aa6-b347-34cdd6253b97",
            "properties": {
                "structure": "MMDDYYYY",
                "separator": "/"
            },
            "validations": {
                "required": false
            },
            "type": "date"
        },
        {
            "id": "EdazGT4AJb0X",
            "title": "TesTitle",
            "ref": "8dd79d05-95e1-4c9c-a7c0-6086e0e58489",
            "validations": {
                "required": false
            },
            "type": "short_text"
        },
        {
            "id": "pzWcYIv4Fzhk",
            "title": "NotDetention?",
            "ref": "19065080-f15a-4c64-8399-4c432d843f16",
            "validations": {
                "required": false
            },
            "type": "short_text"
        },
        {
            "id": "EYy2JbQU0g8B",
            "title": "BILLL",
            "ref": "02e88270-1a36-438c-b08c-8bc9acc5270b",
            "properties": {
                "alphabetical_order": false,
                "choices": [
                    {
                        "label": "Local"
                    },
                    {
                        "label": "MultiNational"
                    }
                ]
            },
            "validations": {
                "required": false
            },
            "type": "dropdown"
        },
        {
            "id": "PQUY2GGzHhLa",
            "title": "Which naational police?",
            "ref": "d6d24d19-dd8b-4a99-b7e7-74be45eb77bc",
            "validations": {
                "required": false
            },
            "type": "short_text"
        },
        {
            "id": "S6qkTwC18V4f",
            "title": "Moreaee comments?",
            "ref": "0f1b253a-3285-4bcd-a454-46d1dbb488da",
            "validations": {
                "required": false
            },
            "type": "short_text"
        }
    ],
    "logic": [
        {
            "type": "field",
            "ref": "02e88270-1a36-438c-b08c-8bc9acc5270b",
            "actions": [
                {
                    "action": "jump",
                    "details": {
                        "to": {
                            "type": "field",
                            "value": "d6d24d19-dd8b-4a99-b7e7-74be45eb77bc"
                        }
                    },
                    "condition": {
                        "op": "equal",
                        "vars": [
                            {
                                "type": "field",
                                "value": "02e88270-1a36-438c-b08c-8bc9acc5270b"
                            },
                            {
                                "type": "constant",
                                "value": "Local"
                            }
                        ]
                    }
                },
                {
                    "action": "jump",
                    "details": {
                        "to": {
                            "type": "field",
                            "value": "0f1b253a-3285-4bcd-a454-46d1dbb488da"
                        }
                    },
                    "condition": {
                        "op": "always",
                        "vars": []
                    }
                }
            ]
        },
        {
            "type": "field",
            "ref": "8dd79d05-95e1-4c9c-a7c0-6086e0e58489",
            "actions": [
                {
                    "action": "jump",
                    "details": {
                        "to": {
                            "type": "field",
                            "value": "19065080-f15a-4c64-8399-4c432d843f16"
                        }
                    },
                    "condition": {
                        "op": "always",
                        "vars": []
                    }
                }
            ]
        }
    ],
    "_links": {
        "display": "https://whistle632914.typeform.com/to/jo8KJj"
    }
}
')
  end

end
