// プロフィール編集　プレビュー表示用の JavaScript
document.addEventListener('turbo:load', function() {
    const inputElement = document.querySelector("#input"); // id="input"を指定したinput要素を選択
    const previewElement = document.querySelector("#preview"); // id="preview"を指定した要素を選択
  
    // inputElement と previewElement が存在する場合のみ処理を実行
  if (inputElement && previewElement) {
    inputElement.addEventListener("change", function() {
      const file = this.files[0];
      if (file) {
        const reader = new FileReader();

        reader.onload = function(e) {
          previewElement.src = e.target.result;
        };

        reader.readAsDataURL(file);
      }
    });
  }
});