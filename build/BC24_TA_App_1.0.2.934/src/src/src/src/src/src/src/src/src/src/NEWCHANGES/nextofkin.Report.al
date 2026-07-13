report 50364 "next of kin"
{
    ApplicationArea = All;
    Caption = 'next of kin';
    UsageCategory = ReportsAndAnalysis;
    // DefaultLayout = Word;
    // WordLayout = './Layouts/EmpFamily.docx';
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/EmpFamily.rdl';
    dataset
    {
        dataitem(HREmployeeKin; "HR Employee Kin")
        {
            column(Code; "Code")
            {
                
            }
            column(DateOfBirth; "Date Of Birth")
            {
            }
            column(EmployeeCode; "Employee Code")
            {
            }
            column(Gender; Gender)
            {
            }
            column(HomeTelNo; "Home Tel No")
            {
            }
            column(IdentificationType; "Identification Type")
            {
            }
            column(OtherNames; "Other Names")
            {
            }
            column(Relationship; Relationship)
            {
            }
            column(SurName; SurName)
            {
            }
            column(Type; "Type")
            {
            }
             column(employeeId;employeeId){}
             column(employeename;employeename){}
             column(compinfopic;compinfo.Picture){}
             column(Branch;Branch){}
             column(Department;Department){}
             column(Title;Title){}
             column(counts;counts){}
             column(Identification_Type;"Identification Type"){}
            trigger OnAfterGetRecord()
            var
            begin
                //counts:=0;
                hremp.Reset();
                hremp.SetRange(hremp."No.","Employee Code");
                // if hremp.FindFirst() then begin
                  employeename:=hremp."First Name"+' '+hremp."Middle Name"+' '+hremp."Last Name";
                  employeeId:=hremp."ID Number";
                  Department:=hremp."Global Dimension 1 Code";
                  Branch:=hremp."Global Dimension 2 Code";
                  counts:=counts+1;

                end;
               
            

            trigger OnPreDataItem()
            begin
                compinfo.get;
                compinfo.CalcFields(Picture);
                Title:='Employee Family List Record form';
            end;
        }
        
    
    }
    var
    hremp: Record "HR-Employee";
    compinfo: Record "Company Information";
    employeename: Text[50];
    employeeId: Code[20];
    Title: text[50];

    Branch: Code[20];
    Department: code[20];
    counts: Integer;
}
   
        

