//  Copyright 2016-2017 Skyscanner Ltd
//
//  Licensed under the Apache License, Version 2.0 (the "License"); 
//  you may not use this file except in compliance with the License. You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software distributed under the License is 
//  distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and limitations under the License.

// MARK: - UITextField extension

import UIKit

extension UITextField {
    
    /// Moves the caret to the correct position by removing the trailing whitespace
    func fixCaretPosition() {
        // Moving the caret to the correct position by removing the trailing whitespace
        // http://stackoverflow.com/questions/14220187/uitextfield-has-trailing-whitespace-after-securetextentry-toggle

        let beginning = beginningOfDocument
        selectedTextRange = textRange(from: beginning, to: beginning)
        let end = endOfDocument
        selectedTextRange = textRange(from: end, to: end)
    }
    
    // Use this to filter out or change the text value without
    // losing the current selection
    func sanitizeText(_ newText: String?, replacement: String = "") {
        guard let text = self.text,
            let selection = selectedTextRange else {
                return
        }
        
        // only execute below if text is different
        guard newText != text else { return }
        
        // determine where new cursor position should start
        // so the cursor doesnt get sent to the end
        let diff = ( newText?.count ?? 0 ) - text.count
        let cursorPosition = offset(from: beginningOfDocument, to: selection.end) + diff
        
        self.text = newText
        
        sendActions(for: .editingChanged)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: { [weak self] in
            if let newPosition = self?.position(from: self?.beginningOfDocument ?? UITextPosition(), offset: cursorPosition) {
                self?.selectedTextRange = self?.textRange(from: newPosition, to: newPosition)
            }
        })
        
    }
    
}
