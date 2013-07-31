# encoding: UTF-8

class Utilities
  
  def self.parse_and_insert_contacts(tempfile,user)
    doc = Nokogiri::XML(tempfile)
    doc.remove_namespaces!
    contacts = []
    doc.xpath("//contacts/contact").each do |contact|
      contact_temp = Contact.new(:name => contact.xpath("./name").inner_text,
                              :lastname => contact.xpath("./lastName").inner_text,
                              :phone => contact.xpath("./phone").inner_text,
                              )
      contact_temp.user = user
      contacts << contact_temp                        
    end
    Contact.import contacts
  end
end