namespace ABH_UAT.ABH_UAT;

page 51572 "Medical Claims Card"
{
    ApplicationArea = All;
    Caption = 'Medical Claims Card';
    PageType = Card;
    SourceTable = "Medical Claims Header";
    
    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                
                field("Claim No"; Rec."Claim No")
                {
                    ToolTip = 'Specifies the value of the Claim No field.', Comment = '%';
                }
                field("Vendor No"; Rec."Vendor No")
                {
                    ToolTip = 'Specifies the value of the Vendor No field.', Comment = '%';
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ToolTip = 'Specifies the value of the Vendor Name field.', Comment = '%';
                }
                field("Vendor TIN No"; Rec."Vendor TIN No")
                {
                    ToolTip = 'Specifies the value of the TIN No field.', Comment = '%';
                }
                field("Vendor VAT Reg No"; Rec."Vendor VAT Reg No")
                {
                    ToolTip = 'Specifies the value of the VAT Reg No field.', Comment = '%';
                }
                field("Vendor Invoice No";"Vendor Invoice No"){}
                field("Invoice No"; Rec."Invoice No")
                {
                    ToolTip = 'Specifies the value of the Invoice No field.', Comment = '%';
                }
                field("Invoice Date"; Rec."Invoice Date")
                {
                    ToolTip = 'Specifies the value of the Invoice Date field.', Comment = '%';
                }
                field("Invoice Amount"; Rec."Invoice Amount")
                {
                    ToolTip = 'Specifies the value of the Invoice Amount field.', Comment = '%';
                }
                field("No of Staff"; Rec."No of Staff")
                {
                    ToolTip = 'Specifies the value of the No of Staff field.', Comment = '%';
                }
                field("Amount to be Paid By Staff"; Rec."Amount to be Paid By Staff")
                {
                    ToolTip = 'Specifies the value of the Amount to be Paid By Staff field.', Comment = '%';
                }
                field("Total expense"; Rec. "Total Company expense")
                {
                    ToolTip = 'Specifies the value of the Total expense field.', Comment = '%';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value of the Remarks field.', Comment = '%';
                }
                field("Created By"; Rec."Created By")
                {
                    ToolTip = 'Specifies the value of the Created By field.', Comment = '%';
                }
                field("Created Date"; Rec."Created Date")
                {
                    ToolTip = 'Specifies the value of the Created By field.', Comment = '%';
                }
            }
            part(Listofpatients;"Medical Claims")
            {
                SubPageLink="Claim No"=field("Claim No"),"Vendor No"=field("Vendor No"),"Invoice No"=field("Invoice No");
            }
        
            
           
        }
        area(FactBoxes)
        {
             part(attachments;"Document Attachments")
            {
                SubPageLink="Table ID"=const(Database::"Medical Claims Header"),"No."=field("Claim No");
            }

        }
        
    }
    
    
    
}
