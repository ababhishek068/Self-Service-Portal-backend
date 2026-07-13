namespace ABH_UAT.ABH_UAT;

page 51559 "loan Guarantee Card"
{
    ApplicationArea = All;
    Caption = 'loan Guarantee Card';    
    PageType = Card;
    SourceTable = "Loan Guarantee Header";
    
    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("Ref No"; Rec."Ref No")
                {
                    ToolTip = 'Specifies the value of the Ref No field.', Comment = '%';
                }               
                
                
                field("Date Defaulted"; Rec."Date Defaulted")
                {
                    ToolTip = 'Specifies the value of the Date Defaulted field.', Comment = '%';
                }
                
                field("Loan Date"; Rec."Loan Date")
                {
                    ToolTip = 'Specifies the value of the Loan Date field.', Comment = '%';
                }
                field("Loan Guarantee No"; Rec."Loan Guarantee No")
                {
                    ToolTip = 'Specifies the value of the Loan Guarantee No field.', Comment = '%';
                }
                field(Loanee; Rec.Loanee)
                {
                    ToolTip = 'Specifies the value of the Loanee field.', Comment = '%';
                }
                field("Loanee Name"; Rec."Loanee Name")
                {
                    ToolTip = 'Specifies the value of the Loanee Name field.', Comment = '%';
                }
                field("Principal Amount"; Rec."Principal Amount")
                {
                    ToolTip = 'Specifies the value of the Principal Amount field.', Comment = '%';
                }
                field("Amount Defaulted"; Rec."Amount Defaulted")
                {
                    ToolTip = 'Specifies the value of the Amount Defaulted field.', Comment = '%';
                }
                field(Installment; Rec.Installment)
                {
                    Editable=false;
                    ToolTip = 'Specifies the value of the Installment field.', Comment = '%';
                }
                field("Amount Recovered"; Rec."Amount Recovered")
                {
                    ToolTip = 'Specifies the value of the Amount Recovered field.', Comment = '%';
                    Editable=false;
                }
                field(Balance; Rec.Balance)
                {
                    ToolTip = 'Specifies the value of the Balance field.', Comment = '%';
                    Editable=false;
                }
                
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
                field("Send to Payroll";"Send to Payroll"){}
                field(Closed; Rec.Closed)
                {
                    ToolTip = 'Specifies the value of the Closed field.', Comment = '%';
                    Editable=false;
                }
                field("Settlement Receipt No";"Settlement Receipt No"){}
                field("Settlement Amount";"Settlement Amount"){}
                
                
            }
            part(Guaranteelines;"Loan Guarantee Loan lines"){
                    SubPageLink="Guarantee No"=field("Loan Guarantee No"),"Ref No"=field("Ref No");
                }
        }
        
        
    }
    

    actions{
        area(Processing)
        {
            action(printloanguarantee){
                
            }
            action(Postrefund)
            {
                Caption='Post Guarantee Refund';
                ApplicationArea=basic;
                Promoted=true;
                PromotedCategory=Process;
                trigger OnAction()
                var
                ask: Boolean;
                begin
                    TestField(rec."Settlement Receipt No");
                    loanlines.Reset();
                    loanlines.SetRange(loanlines."Ref No",Rec."Ref No");
                    //loanlines.SetRange(loanlines.);
                    ask:=Confirm('')



                end;
            }
        }
    }
    var
    hremps: Record "HR-Employee";
    loanlines: Record "Loan Guarantee Lines";
    premplines: Record "PR Employee Transactions";
    vitalsetup: Record "PR Vital Setup Info";
    prperiods: Record "PR Payroll Periods";
    
}
