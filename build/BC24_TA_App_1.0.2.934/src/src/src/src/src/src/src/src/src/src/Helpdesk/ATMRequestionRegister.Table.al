Table 50998 "ATM Requestion Register"
{
    DrillDownPageID = "Deployment Lines";
    LookupPageID = "Deployment Lines";

    fields
    {
        field(1;"Requestion No";Code[10])
        {
            Editable = false;

            trigger OnValidate()
            begin
                if "Requestion No" <> xRec."Requestion No" then begin
                 ATMSetup.Get;
                  NoSeriesMgt.TestManual(ATMSetup."Requestion No");
                  "No. Series" := '';
                end;
            end;
        }
        field(2;"Case Description";Text[150])
        {
        }
        field(3;"SR Number";Code[30])
        {
        }
        field(4;"Requestion date";Date)
        {
        }
        field(5;"Customer No";Code[10])
        {
            TableRelation = Customer."No.";

            trigger OnValidate()
            begin
                 if cust.Get("Customer No") then
                   "Customer Name":=cust.Name;
            end;
        }
        field(6;"Customer Name";Text[50])
        {
        }
        field(7;country;Code[30])
        {
            TableRelation = "Country/Region".Code;
        }
        field(8;Branch;Code[100])
        {
            TableRelation = "Post Code".City;
        }
        field(9;Street;Code[30])
        {
        }
        field(10;"Physical loation";Text[50])
        {
        }
        field(11;"Part Category";Option)
        {
            BlankZero = true;
            OptionCaption = ',Hardware,Software';
            OptionMembers = ,Hardware,Software;
        }
        field(12;"No. Series";Code[20])
        {
        }
        field(13;"Requesting Engineer No";Code[10])
        {
            TableRelation = "HR-Employee"."No.";
            trigger OnValidate()

           
            begin
                if hrenginer.Get("Requesting Engineer No") then
                 "Engineer Name":=hrenginer."First Name"+' '+hrenginer."Last Name";
            end;
        }
        field(14;"Engineer Name";Text[30])
        {
        }
        field(15;"Created By";Code[30])
        {
            Editable = false;
        }
        field(16;Created;Boolean)
        {
            Editable = false;
        }
        field(17;"Requestion Send";Boolean)
        {
        }
        field(18;"ATM Type code";Code[50])
        {
            TableRelation = "ATM Model Setup".Code;

            trigger OnValidate()
            begin
                if Atmmodule.Get("ATM Type code") then begin
                  "ATM Type code":="ATM Type code";
                "Atm Type":=Atmmodule."ATM Model";
                "Atm Dimensions":=Atmmodule.Dimension;
                "Camera Installed":=Atmmodule."Camera Installed";
                Cassettes:=Atmmodule.cassettes;
                "Receipt Printer":=Atmmodule."Receipt Printer";
                "Touch Screen":=Atmmodule."Touch Screen";
                "Screen Size":=Atmmodule."Screen Size";
                end;
            end;
        }
        field(19;"Atm Type";Text[50])
        {
        }
        field(20;"Atm Dimensions";Code[30])
        {
        }
        field(21;"Camera Installed";Option)
        {
            OptionMembers = ,Yes,Nos;
        }
        field(22;Cassettes;Code[10])
        {
        }
        field(23;"Receipt Printer";Code[50])
        {
        }
        field(24;"Touch Screen";Option)
        {
            OptionCaption = ',Yes,No';
            OptionMembers = ,Yes,No;
        }
        field(25;"Screen Size";Code[30])
        {
        }
        field(26;"ATM NO";Code[10])
        {
            TableRelation = "ATM Register."."ATM No";

            trigger OnValidate()
            begin
                if ATMReg.Get("ATM NO")then
                  begin
                    "Customer No":=ATMReg."Customer No";
                    "Customer Name":=DelChr(ATMReg."Customer Name",'=','àû|@|#|$|%|^|?|<|>|''|"|!|*\|/|&|;|:|"|.|-|(|)');
                    "Atm Type":=ATMReg."Atm model";
                    country:=ATMReg.country;
                    Street:=ATMReg.Street;
                    "Physical loation":=DelChr(ATMReg."Physical loation",'=','àû|@|#|$|%|^|?|<|>|''|"|!|*\|/|&|;|:|"|.|-|(|)');
                    "atm name":=DelChr(ATMReg.Description,'=','àû|@|#|$|%|^|?|<|>|''|"|!|*\|/|&|;|:|"|.|-|(|)');
                    Branch:=ATMReg.Branch;
                    "Atm Dimensions":=ATMReg."Atm Dimensions";
                    Cassettes:=ATMReg.Cassettes;
                    "Receipt Printer":=ATMReg."Receipt Printer";
                    "Touch Screen":=ATMReg."Touch Screen";
                    "Screen Size":=ATMReg."Screen Size";
                end;
            end;
        }
        field(27;issued;Option)
        {
            OptionCaption = 'yes,no';
            OptionMembers = yes,no;
        }
        field(28;"Case Nos";Code[10])
        {
            TableRelation = "ATM Cases Management"."Case Number";

            trigger OnValidate()
            begin
                ReqReg.Reset;
                ReqReg.SetRange(ReqReg."Case No","Case Nos");
                if ReqReg.Find('-') then
                  Error('A requisition for this case no: '+ReqReg."Case No" +' was escalated on '+Format(ReqReg."Date Escalated"));


                CaseLogs.Reset;
                CaseLogs.SetRange(CaseLogs."Case Number","Case Nos");
                if CaseLogs.Find('-')then begin
                  "SR Number":=CaseLogs."SR Number";
                  "ATM NO":=CaseLogs."ATM No";
                  "Atm Type":=CaseLogs."ATM Type";
                  "Atm Dimensions":=CaseLogs."Atm Dimensions";
                  "Customer No":=CaseLogs."Client Code";
                  "Customer Name":=CaseLogs."Account Name";
                  //"cause of error":=CaseLogs."cause of error";
                  "Case Description":=CaseLogs."Case Description";
                  "ATM DESCRIPTION":=CaseLogs."ATM Name";
                  if ATMReg.Get("ATM NO") then
                    //"ATM DESCRIPTION":=ATMReg.Description;
                  "Physical loation":=ATMReg."Physical loation";
                  country:=ATMReg.country;
                  Branch:=ATMReg.Branch;
                  Street:=ATMReg.Street;



                  end;

            end;
        }
        field(29;"Total Quantity Requested";Integer)
        {
            CalcFormula = count("Hardware Component Line" where ("Requestion No"=field("Requestion No")));
            FieldClass = FlowField;
        }
        field(30;"ATM DESCRIPTION";Text[100])
        {
        }
        field(31;"atm name";Text[100])
        {
        }
        field(32;"Requistion Type";Option)
        {
            OptionCaption = ',ATM,KIOSK';
            OptionMembers = ,ATM,KIOSK;
        }
        field(33;"Case Type";Option)
        {
            OptionCaption = ',ATM,Kiosk';
            OptionMembers = ,ATM,Kiosk;
        }
        field(34;"cause of error";Text[100])
        {
        }
        field(35;Status;Option)
        {
            OptionCaption = 'New,Pending,Approved,Pending Approval,1st Approver,Second Approver,Third Approver';
            OptionMembers = New,Pending,Approved,"Pending Approval","1st Approver","Second Approver","Third Approver";
        }
        field(36;"App Req No";Code[20])
        {
        }
        field(37;"Email send";Boolean)
        {
        }
        field(38;"Date Email Send";Date)
        {
        }
        field(39;"Time Email Send";Time)
        {
        }
    }

    keys
    {
        key(Key1;"Requestion No","ATM NO")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if "Requestion No" = '' then begin
          ATMSetup.Get;
          ATMSetup.TestField(ATMSetup."Requestion No");
          "Requestion No":=NoSeriesMgt.GetNextNo(ATMSetup."Requestion No",today,true);
          "Requestion date":=Today;
          "Created By":=UserId;
        end;
    end;

    var
        ATMSetup: Record "HR Setup";
        NoSeriesMgt: Codeunit "No. Series";
        hrenginer: Record "HR-Employee";
        cust: Record Customer;
        Atmmodule: Record "ATM Model Setup";
        ATMReg: Record "ATM Register.";
        CaseLogs: Record "ATM Cases Management";
        ReqReg: Record "Requisition Register";


    procedure Escalate()
    var
        NewRecordsHeader: Record "Requisition Register";
        NewRecordsLine: Record "Component Line Register";
        RequisitionLines: Record "Hardware Component Line";
    begin
        //******Insert New Header Records**********
        if "Requestion Send"=true then
          Error('Requestion already escalated') else
          if "Requestion Send"=false then begin
          //NewRecordsLine.TESTFIELD(Description);
        //NewRecordsLine.TESTFIELD(Quantity);
        NewRecordsHeader.Init;
          NewRecordsHeader."Requestion No":="Requestion No";
          NewRecordsHeader."Case Description":="cause of error";
          NewRecordsHeader."SR Number":="SR Number";
          NewRecordsHeader."Case No":="Case Nos";
          NewRecordsHeader."Requestion date":="Requestion date";
          NewRecordsHeader."Customer No":="Customer No";
          NewRecordsHeader."Customer Name":="Customer Name";
          NewRecordsHeader.country:=country;
          NewRecordsHeader.Branch:=Branch;
          NewRecordsHeader.Street:=Street;
          NewRecordsHeader."Physical loation":="Physical loation";
          NewRecordsHeader."Part Category":="Part Category";
          NewRecordsHeader."Requesting Engineer No":="Requesting Engineer No";
          NewRecordsHeader."Engineer Name":="Engineer Name";
          NewRecordsHeader."ATM Type code":="ATM Type code";
          NewRecordsHeader."Atm Type":="Atm Type";
          NewRecordsHeader."Atm Dimensions":="Atm Dimensions";
          NewRecordsHeader."ATM NO":="ATM NO";
          NewRecordsHeader."Date Escalated":=Today;
          NewRecordsHeader."Created By":="Created By";
          NewRecordsHeader.Insert;
          //*****END Newrecords Header******
        //******** Insert new Components lines************



        RequisitionLines.Reset;
        RequisitionLines.SetRange(RequisitionLines."Requestion No","Requestion No");
        RequisitionLines.SetRange(RequisitionLines."Requestion Send",false);
        if RequisitionLines.FindFirst then begin repeat
          NewRecordsLine.Init;
          NewRecordsLine."Requestion No":="Requestion No";
          NewRecordsLine."Case no":="Case Nos";
          NewRecordsLine."Entry No":=NewRecordsLine."Entry No"+100;
          NewRecordsLine."Part No":=RequisitionLines."Part No";
          NewRecordsLine.Description:=RequisitionLines.Description;
          NewRecordsLine.Quantity:=RequisitionLines.Quantity;
          NewRecordsLine.compulsory:=RequisitionLines.compulsory;
          NewRecordsLine."Unit price":=RequisitionLines."Unit price";
          NewRecordsLine."Atm No":="ATM NO";
          NewRecordsLine."To be Billed":=RequisitionLines."to bill";
          NewRecordsLine.Status:=RequisitionLines.Status;
          NewRecordsLine.Category:=RequisitionLines.Category;
          NewRecordsLine.Insert;
          RequisitionLines."Requestion Send":=true;
          RequisitionLines.Modify;
          until RequisitionLines.Next=0;
          end;
          "Requestion Send":=true
            end;
           //*****END newrecords line Header******
          Message('Atm parts Successfully escalated to Store manager');
    end;

    local procedure testfield()
    begin
    end;
}

