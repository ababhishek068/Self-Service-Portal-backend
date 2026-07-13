namespace ABH_UAT.ABH_UAT;

page 51573 "Cash Indemnity Card"
{
    ApplicationArea = All;
    Caption = 'Cash Indemnity Card';
    PageType = Card;
    SourceTable = "Cash Indemnity Header";
    
    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                
                field("Cash Idemnity Code"; Rec."Cash Idemnity Code")
                {
                    ToolTip = 'Specifies the value of the Cash Idemnity Code field.', Comment = '%';
                }
                field("Payroll Period"; Rec."Payroll Period")
                {
                    ToolTip = 'Specifies the value of the Payroll Period field.', Comment = '%';
                }
                field("Payroll Month"; Rec."Payroll Month")
                {
                    ToolTip = 'Specifies the value of the Payroll Month field.', Comment = '%';
                }
                field("Payroll Year"; Rec."Payroll Year")
                {
                    ToolTip = 'Specifies the value of the Payroll Year field.', Comment = '%';
                }
                field("No of Working Days";"No of Working Days"){}
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
                field("Created By"; Rec."Created By")
                {
                    ToolTip = 'Specifies the value of the Created By field.', Comment = '%';
                }
                field("Date Created"; Rec."Date Created")
                {
                    ToolTip = 'Specifies the value of the Date Created field.', Comment = '%';
                }
                field("Total Cash Indemnity"; Rec."Total Cash Indemnity")
                {
                    ToolTip = 'Specifies the value of the Total Cash Indemnity field.', Comment = '%';
                }
                
            }
            part(stafflist;"Cash Indemnity Staff List")
                {
                    SubPageLink="Cash Indeminity Code"=field("Cash Idemnity Code"),"Payroll Period"=field("Payroll Period");
                }
            
        }
        area(FactBoxes)
        {
            part(attacheddocs;"Document Attachments")
            {
                SubPageLink="Table ID"=const(Database::"Cash Indemnity Header"),"No."=field("Cash Idemnity Code");
            }
        }
    }
}
