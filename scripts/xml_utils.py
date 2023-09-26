#import pdb
import xml.etree.ElementTree as ET

#pdb.set_trace()

def modify_xml_config(template_file, output_file, modifications):
    # Load the template XML file
    tree = ET.parse(template_file)
    root = tree.getroot()

    # Apply modifications to the XML tree
    for xpath, new_value in modifications.items():
        elements = root.findall(xpath)
        for element in elements:
            element.text = new_value

    # Write the modified XML tree to the output file
    tree.write(output_file)


