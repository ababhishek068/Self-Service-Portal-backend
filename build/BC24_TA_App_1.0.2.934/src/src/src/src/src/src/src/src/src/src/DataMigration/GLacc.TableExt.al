// namespace ABH_UAT.ABH_UAT;

// using Microsoft.Finance.GeneralLedger.Account;

// tableextension 50053 GLacc extends "G/L Account"
// {
//     fields
//     {
        
//     }

//     trigger OnModify()
//     var
    
//         MyAccount: Record "My Account";
        
//         IsHandled: Boolean;
//     begin
//         IsHandled := false;
//         OnBeforeOnedit(Rec."No.", IsHandled);
//         if IsHandled then
//             exit;
//     end;
//     [IntegrationEvent(false, false)]
//     local procedure OnBeforeOnedit(var GLAccount: code[40]; var IsHandled: Boolean)
//     begin
//     end;
// }


