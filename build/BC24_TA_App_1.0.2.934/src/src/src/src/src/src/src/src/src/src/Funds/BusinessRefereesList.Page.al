Page 51419 "Business Referees List"
{
    PageType = ListPart;
    SourceTable = "CompanyInfo Business Referees";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(CompanyInfoQuestionaireNo; Rec."CompanyInfo Questionaire No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the CompanyInfo Questionaire No field.';
                }
                field("TIN No"; Rec."TIN No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the PIN No. field.';
                }
                field(NameOfCompany; Rec."Name Of Company")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Name Of Company field.';
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Address field.';
                }
                field(TelephoneNo; Rec."Telephone No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Telephone No field.';
                }
                field(ContactPerson; Rec."Contact Person")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Contact Person field.';
                }
                field(ContractValue; Rec."Contract Value")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Contract Value field.';
                }
                field(FromDate; Rec."From Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the From Date field.';
                }
                field(ToDate; Rec."To Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the To Date field.';
                }
            }
        }
    }

    actions { }
}

