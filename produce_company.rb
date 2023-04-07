module ProduceCompany
   attr_accessor :company_name
        
  def produce_company
    puts "Введите название производителя"
    company=gets.chomp
    self.company_name=company
  end
  
end
